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
    func clearExpiredDataFromCache(forceClear: Bool) throws
}

// MARK: - CacheManager
class CacheManager<T: Cacheable>: CacheService where T: PersistentModel {
    private let modelType: T.Type
    private let context: ModelContext
    private let cacheDuration: TimeInterval = AppSetting.shared.cacheExpirationTime
    
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
    
    func clearExpiredDataFromCache(forceClear: Bool = false) throws {
        let calendar = Calendar.current
        let expiredDate = calendar.date(byAdding: .second, value: Int(-cacheDuration), to: Date())!
        
        /* fetch all items */
        let allDataDescriptor = FetchDescriptor<T>()
        let allItems = try context.fetch(allDataDescriptor)
        
        /* no items in cache to clear */
        guard !allItems.isEmpty else {
            return
        }
        
        do {
            /* clear all data with force clear if need */
            if forceClear {
                for item in allItems {
                    context.delete(item)
                }
                try context.save()
                return
            }
            
            /* check condition and get expired items */
            let predicate = #Predicate<T> { item in
                item.cachedAt <= expiredDate
            }
            let descriptor = FetchDescriptor<T>(predicate: predicate)
            let expiredItems = try context.fetch(descriptor)
            
            if !expiredItems.isEmpty {
                for item in expiredItems {
                    context.delete(item)
                }
                try context.save()
            }
            
        } catch {
            throw error
        }
    }
}
