//
//  CacheManager.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 19/4/25.
//

import Foundation
import SwiftData
import UIKit

// MARK: - CacheService
protocol CacheService {
    associatedtype T: Cacheable
    func saveDataToCache(items: [T]) async throws
    func fetchDataFromCache() throws -> [T]
    func clearExpiredDataFromCache() throws
}

// MARK: - CacheManager
class CacheManager<T: Cacheable>: CacheService where T: PersistentModel {
    private let modelType: T.Type
    private let context: ModelContext
    private let cacheDuration: TimeInterval = 300 // 5 minutes
    
    init(modelType: T.Type, context: ModelContext) {
        self.modelType = modelType
        self.context = context
    }
    
    func saveDataToCache(items: [T]) async throws {
        let imageLoader = ImageLoader<T>()
        for item in items {
            /* cache image if model contain imageURL field is not empty */
            if let imageData = await imageLoader.loadImage(for: item) {
                item.cachedImage = imageData
            }
            context.insert(item)
        }
        try context.save()
    }
    
    /* load data from cache if avaliable */
    func fetchDataFromCache() throws -> [T] {
        let descriptor = FetchDescriptor<T>(
            sortBy: [SortDescriptor(\T.id)]
        )
        return try context.fetch(descriptor)
    }
    
    func clearExpiredDataFromCache() throws {
        let calendar = Calendar.current
        let expiredDate = calendar.date(byAdding: .second, value: Int(-cacheDuration), to: Date())!
        
        /* fetch all items */
        let allDataDescriptor = FetchDescriptor<T>()
        let allItems = try context.fetch(allDataDescriptor)
        
        /* no items in cache to clear */
        guard !allItems.isEmpty else {
            return
        }
        
        /* check for expired items */
        let predicate = #Predicate<T> { item in
            item.cachedAt <= expiredDate
        }
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        let expiredItems = try context.fetch(descriptor)
        
        /* only clear cache if all items is expired */
        if expiredItems.count == allItems.count {
            for item in allItems {
                context.delete(item)
            }
            try context.save()
        } else {
            #if DEBUG
            print("some items not expired yet, need to keep all data in cache")
            #endif
        }
    }
}
