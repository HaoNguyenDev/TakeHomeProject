//
//  UserListViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
import SwiftData
@testable import GitHubUsers

@MainActor
final class UserListViewModelTests: XCTestCase {
    var sut: UserListViewModel!
    var mockNetworkService: MockGitHubService!
    var mockCacheManager: MockCacheManager<User>!
    var mockSwiftDataContainer: MockSwiftDataContainer!
    var paginationConfig: PaginationConfig!
    var context: ModelContext!
    override func setUp() {
        super.setUp()
        do {
            // Setup SwiftData
            mockSwiftDataContainer = try MockSwiftDataContainer()
            let context = mockSwiftDataContainer.createContext()
            
            // Setup mocks
            mockNetworkService = MockGitHubService()
                        mockCacheManager = MockCacheManager(modelType: User.self, context: context)
                        paginationConfig = PaginationConfig(perPage: 10, since: 0)
            
            // Setup SUT
            sut = UserListViewModel(
                networkService: mockNetworkService,
                cacheService: mockCacheManager,
                paginationConfig: paginationConfig
            )
        } catch {
            XCTFail("Failed to initialize test environment: \(error)")
        }
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockCacheManager = nil
        mockSwiftDataContainer = nil
        paginationConfig = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState() {
        XCTAssertEqual(sut.users, [])
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testFetchUsers_WhenNetworkFails_ShouldSetError() async {
        // Given
        mockNetworkService.shouldSucceed = false
        mockCacheManager.mockCachedUsers = []
        
        // When
        await sut.fetchUsers()
        
        // Then
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchUsers_WhenCacheIsEmpty_ShouldFetchFromNetwork() async {
        // Given
        let mockUsers = MockUsersModel.mockUserArray
        mockNetworkService.mockUsers = mockUsers
        mockCacheManager.mockCachedUsers = []
        
        // When
        await sut.fetchUsers()
        
        // Then
        XCTAssertEqual(sut.users.count, 5)
        XCTAssertEqual(sut.users[0].id, 1)
        XCTAssertEqual(sut.users[1].id, 2)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testFetchUsers_WhenCacheHasData_ShouldUseCachedData() async {
        // Given
        let cachedUsers = MockUsersModel.mockUserArray
        mockCacheManager.mockCachedUsers = cachedUsers
        
        // When
        await sut.fetchUsers()
        
        // Then
        XCTAssertEqual(sut.users.count, 5)
        XCTAssertEqual(sut.users[0].id, 1)
        XCTAssertEqual(sut.users[1].id, 2)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testLoadMoreUser_ShouldAppendNewUsers() async {
        // Given
        let initialUsers = MockUsersModel.mockUserArray
        let newUsers = MockUsersModel.mockLoadMoreUserArray
        sut.users = initialUsers
        mockNetworkService.mockUsers = newUsers
        
        // When
        await sut.loadMoreUser()
        
        // Then
        XCTAssertEqual(sut.users.count, 10)
        XCTAssertEqual(sut.users[7].id, 8)
        XCTAssertNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
    
    func testUpdatePagination_ShouldUpdateSinceParameter() {
        // Given
        let users = MockUsersModel.mockLoadMoreUserArray
        
        // When
        sut.updatePagination(from: users)
        
        // Then
        XCTAssertEqual(sut.testPaginationConfig.since, 10)
    }
    
    func test_updatePagination_withEmptyUsers_shouldNotUpdateSince() {
        // Given
        let emptyUsers = MockUsersModel.mockEmptyUserArray
        let initialSince = sut.testPaginationConfig.since
        
        // When
        sut.updatePagination(from: emptyUsers)
        
        // Then
        XCTAssertEqual(sut.testPaginationConfig.since, initialSince)
    }
}
