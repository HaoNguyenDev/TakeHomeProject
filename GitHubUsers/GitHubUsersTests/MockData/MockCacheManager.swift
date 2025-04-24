//
//  MockCacheManager.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
import SwiftData
@testable import GitHubUsers

class MockCacheManager<T: Cacheable>: CacheManager<T> where T: PersistentModel {
    // MARK: - Properties
    
    var mockCachedUsers: [T] = []
    private let cacheDuration: TimeInterval = 300 // 5 minutes
    private var appSetting: AppSettingProtocol!
    // MARK: - Initialization
    private let modelType: T.Type
    private let context: ModelContext
    
    override init(modelType: T.Type, context: ModelContext, appSetting: AppSettingProtocol) {
        self.modelType = modelType
        self.context = context
        super.init(modelType: modelType, context: context, appSetting: appSetting)
    }
    
    // MARK: - CacheService Methods
    override func saveDataToCache(items: [T]) async throws {
        mockCachedUsers = items
    }
    
    override func fetchDataFromCache() throws -> [T] {
        return mockCachedUsers
    }
    
    override func clearExpiredDataFromCache(forceClear: Bool = false) throws {
        if forceClear {
            mockCachedUsers.removeAll()
            return
        }
        
        let calendar = Calendar.current
        let expiredDate = calendar.date(byAdding: .second, value: Int(-cacheDuration), to: Date())!
        
        let expiredItems = mockCachedUsers.filter { $0.cachedAt <= expiredDate }
        if expiredItems.count == mockCachedUsers.count {
            mockCachedUsers.removeAll()
        }
    }
    
    // MARK: - Test Helper Methods
    func reset() {
        mockCachedUsers.removeAll()
    }
}

