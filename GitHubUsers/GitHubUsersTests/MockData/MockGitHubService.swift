//
//  MockGitHubService.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

class MockGitHubService: GitHubServiceProtocol {
    
    var shouldSucceed = true
    var mockUsers: [User] = MockUsersModel.mockUserArray
    var mockUsersDetail: UserDetail = MockUserDetailModel.mockUserDetail
    
    func fetchUsers(perPage: Int, since: Int) async throws -> [User] {
        if shouldSucceed {
            return mockUsers
        } else {
            throw GitHubServiceError.invalidResponse(statusCode: 401)
        }
    }
    
    func fetchUserDetail(by username: String) async throws -> GitHubUsers.UserDetail {
        if shouldSucceed {
            return mockUsersDetail
        } else {
            throw GitHubServiceError.invalidResponse(statusCode: 401)
        }
    }
}
