//
//  GitHubNetworkServiceTest.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

class GitHubNetworkServiceTest: XCTestCase {
    var sut: GitHubNetworkService!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = GitHubNetworkService(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Users Tests
    func test_fetchUsers_success() async throws {
        // Given
        let perPage = 10
        let since = 0
        let mockUsers = MockUsersModel.mockUserArray
        mockNetworkManager.mockResult = .success(mockUsers)
        
        // When
        let result = try await sut.fetchUsers(perPage: perPage, since: since)
        
        // Then
        XCTAssertEqual(result.count, mockUsers.count)
        XCTAssertEqual(result[0].id, mockUsers[0].id)
        XCTAssertEqual(result[0].login, mockUsers[0].login)
        XCTAssertEqual(result[0].avatarUrl, mockUsers[0].avatarUrl)
    }
    
    func test_fetchUsers_failure() async {
        // Given
        let perPage = 10
        let since = 0
        mockNetworkManager.mockResult = .failure(GitHubServiceError.invalidResponse(statusCode: 401))
        
        // When/Then
        do {
            _ = try await sut.fetchUsers(perPage: perPage, since: since)
            XCTFail("Expected error")
        } catch let error as GitHubServiceError {
            XCTAssertEqual(error.errorDescription, GitHubServiceError.invalidResponse(statusCode: 401).errorDescription)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    // MARK: - Fetch User Detail Tests
    func test_fetchUserDetail_success() async throws {
        // Given
        let username = "testUser"
        let mockUserDetail = MockUserDetailModel.mockUserDetail
        mockNetworkManager.mockResult = .success(mockUserDetail)
        
        // When
        let result = try await sut.fetchUserDetail(by: username)
        
        // Then
        XCTAssertEqual(result.id, mockUserDetail.id)
        XCTAssertEqual(result.login, mockUserDetail.login)
        XCTAssertEqual(result.name, mockUserDetail.name)
        XCTAssertEqual(result.avatarUrl, mockUserDetail.avatarUrl)
        XCTAssertEqual(result.location, mockUserDetail.location)
        XCTAssertEqual(result.followers, mockUserDetail.followers)
        XCTAssertEqual(result.following, mockUserDetail.following)
        XCTAssertEqual(result.blog, mockUserDetail.blog)
    }
    
    func test_fetchUserDetail_failure() async {
        // Given
        let username = "testUser"
        mockNetworkManager.mockResult = .failure(GitHubServiceError.invalidResponse(statusCode: 404))
        
        // When/Then
        do {
            _ = try await sut.fetchUserDetail(by: username)
            XCTFail("Expected error")
        } catch let error as GitHubServiceError {
            XCTAssertEqual(error.errorDescription, GitHubServiceError.invalidResponse(statusCode: 404).errorDescription)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
