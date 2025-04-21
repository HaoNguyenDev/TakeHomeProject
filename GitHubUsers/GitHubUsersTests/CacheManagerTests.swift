//
//  CacheManagerTests.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
import SwiftData
@testable import GitHubUsers

@MainActor
final class CacheManagerTests: XCTestCase {
    var sut: MockCacheManager<User>!
    var mockContainer: MockSwiftDataContainer!
    var context: ModelContext!
    
    override func setUp() {
        super.setUp()
        do {
            mockContainer = try MockSwiftDataContainer()
            context = mockContainer.createContext()
            sut = MockCacheManager(modelType: User.self, context: context)
        } catch {
            XCTFail("Failed to initialize test environment: \(error)")
        }
    }
    
    override func tearDown() {
        sut.reset() // Reset mock cache
        sut = nil
        context = nil
        mockContainer = nil
        super.tearDown()
    }
    
    // MARK: - Save Data Tests
    func test_saveDataToCache() async throws {
        // Given
        let users = createMockTestUsers()
        
        // When
        try await sut.saveDataToCache(items: users)
        
        // Then
        let savedUsers = try sut.fetchDataFromCache()
        XCTAssertEqual(savedUsers.count, users.count)
        
        // Verify each user
        for (index, savedUser) in savedUsers.enumerated() {
            XCTAssertEqual(savedUser.id, users[index].id)
            XCTAssertEqual(savedUser.login, users[index].login)
        }
    }
    
    // MARK: - Fetch Data Tests
    func test_fetchDataFromCache_success() throws {
        // Given
        sut.mockCachedUsers = createMockTestUsers()
        
        // When
        let users = try sut.fetchDataFromCache()
        
        // Then
        XCTAssertFalse(users.isEmpty)
    }
    
    // MARK: - Clear Cache Tests
    func test_clearExpiredDataFromCache_allExpired() async throws {
        // Given
        let users = createMockTestUsers(withExpiredCache: true)
        try await sut.saveDataToCache(items: users)
        
        // When
        try sut.clearExpiredDataFromCache()
        
        // Then
        let remainingUsers = try sut.fetchDataFromCache()
        XCTAssertTrue(remainingUsers.isEmpty)
    }
    
    func test_clearExpiredDataFromCache_noneExpired() async throws {
        // Given
        let users = createMockTestUsers(withExpiredCache: false)
        try await sut.saveDataToCache(items: users)
        
        // When
        try sut.clearExpiredDataFromCache()
        
        // Then
        let remainingUsers = try sut.fetchDataFromCache()
        XCTAssertEqual(remainingUsers.count, users.count)
    }
    
    func test_clearExpiredDataFromCache_withForceClear() async throws {
        // Given
        let users = createMockTestUsers()
        try await sut.saveDataToCache(items: users)
        
        // When
        try sut.clearExpiredDataFromCache(forceClear: true)
        
        // Then
        let remainingUsers = try sut.fetchDataFromCache()
        XCTAssertTrue(remainingUsers.isEmpty)
    }
}

extension CacheManagerTests {
    private func createMockTestUsers(count: Int = 10, withExpiredCache: Bool = false) -> [User] {
        var users: [User] = []
        let calendar = Calendar.current
        let now = Date()
        
        for i in 1...count {
            let user = User(id: i,
                            login: "test_user_\(i)",
                            avatarUrl: "https://test.com/avatar/\(i).jpg",
                            url: "https://api.github.com/users/test_user_\(i)",
                            imageURL: "https://test.com/avatar/\(i).jpg")
            if withExpiredCache {
                user.cachedAt = calendar.date(byAdding: .minute, value: -10, to: now)!
            } else {
                user.cachedAt = calendar.date(byAdding: .minute, value: -1, to: now)!
            }
            users.append(user)
        }
        return users
    }
}
