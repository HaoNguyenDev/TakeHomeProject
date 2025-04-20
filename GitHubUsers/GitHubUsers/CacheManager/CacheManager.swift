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
    private let cacheDuration: TimeInterval = 300 // 3 minutes
    
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
        
        let predicate = #Predicate<T> { item in
            item.cachedAt <= expiredDate
        }
        
        let descriptor = FetchDescriptor<T>(predicate: predicate)
        let expiredItems = try context.fetch(descriptor)
        #if DEBUG
        print("Clearing \(expiredItems.count) expired items from cache")
        #endif
        
        /* this handle just clear the data expired only, not clear all of them */
        //        if !expiredItems.isEmpty {
        //            for item in expiredItems {
        //                context.delete(item)
        //            }
        //            try context.save()
        //        }
        
        /* more handle to clear all data from cache if one of them expired, then we need fetch new data */
        if !expiredItems.isEmpty {
            #if DEBUG
            print("Found \(expiredItems.count) expired items. About to clear all data from cache.")
            #endif
            let allDataDescriptor = FetchDescriptor<T>()
            let allItems = try context.fetch(allDataDescriptor)
            for item in allItems {
                context.delete(item)
            }
            
            try context.save()
        }
    }
}
