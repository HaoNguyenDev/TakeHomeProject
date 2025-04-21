//
//  UserDetailViewModelTest.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

@MainActor
final class UserDetailViewModelTests: XCTestCase {
    var sut: UserDetailViewModel!
    var mockNetworkService: MockGitHubService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockGitHubService()
        sut = UserDetailViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    func test_initialState() {
        XCTAssertNil(sut.usersDetail)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    // MARK: - Fetch User Detail Tests
    func test_fetchUserDetail_success() async {
        // Given
        let username = "testUser"
        let mockUserDetail = MockUserDetailModel.mockUserDetail
        mockNetworkService.mockUsersDetail = mockUserDetail
        mockNetworkService.shouldSucceed = true
        
        // When
        await sut.fetchUsers(by: username)
        
        // Then
        XCTAssertNotNil(sut.usersDetail)
        XCTAssertEqual(sut.usersDetail?.id, mockUserDetail.id)
        XCTAssertEqual(sut.usersDetail?.login, mockUserDetail.login)
        XCTAssertEqual(sut.usersDetail?.name, mockUserDetail.name)
        XCTAssertEqual(sut.usersDetail?.avatarUrl, mockUserDetail.avatarUrl)
        XCTAssertEqual(sut.usersDetail?.location, mockUserDetail.location)
        XCTAssertEqual(sut.usersDetail?.followers, mockUserDetail.followers)
        XCTAssertEqual(sut.usersDetail?.following, mockUserDetail.following)
        XCTAssertEqual(sut.usersDetail?.blog, mockUserDetail.blog)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func test_fetchUserDetail_failure() async {
        // Given
        let username = "testUser"
        mockNetworkService.shouldSucceed = false
        
        // When
        await sut.fetchUsers(by: username)
        
        // Then
        XCTAssertNil(sut.usersDetail)
        XCTAssertNotNil(sut.error)
        XCTAssertFalse(sut.isLoading)
    }
}
