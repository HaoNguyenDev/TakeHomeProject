//
//  GitHubAPIEndpointTests.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

final class GitHubAPIEndpointTests: XCTestCase {
    
    func testGetUsersEndpoint() {
        // Given
        let perPage = 30
        let since = 0
        
        // When
        let endpoint = GitHubAPIEndpoint.getUsersEndpoint(perPage: perPage, since: since)
        
        // Then
        XCTAssertEqual(endpoint.baseURL, "https://api.github.com")
        XCTAssertEqual(endpoint.path, "/users")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.queryParameters?["per_page"], "30")
        XCTAssertEqual(endpoint.queryParameters?["since"], "0")
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json;charset=utf-8")
    }
    
    func testGetUserDetailEndpoint() {
        // Given
        let username = "testuser"
        
        // When
        let endpoint = GitHubAPIEndpoint.getUserDetailEndpoint(username: username)
        
        // Then
        XCTAssertEqual(endpoint.baseURL, "https://api.github.com")
        XCTAssertEqual(endpoint.path, "/users/testuser")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertNil(endpoint.queryParameters)
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json;charset=utf-8")
    }
    
    func testGetUserDetailEndpointWithSpecialCharacters() {
        // Given
        let username = "test * user"
        
        // When
        let endpoint = GitHubAPIEndpoint.getUserDetailEndpoint(username: username)
        
        // Then
        XCTAssertEqual(endpoint.baseURL, "https://api.github.com")
        XCTAssertEqual(endpoint.path, "/users/test * user")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertNil(endpoint.queryParameters)
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json;charset=utf-8")
    }
    
    func testGetUsersEndpointWithDifferentParameters() {
        // Given
        let perPage = 100
        let since = 1000
        
        // When
        let endpoint = GitHubAPIEndpoint.getUsersEndpoint(perPage: perPage, since: since)
        
        // Then
        XCTAssertEqual(endpoint.baseURL, "https://api.github.com")
        XCTAssertEqual(endpoint.path, "/users")
        XCTAssertEqual(endpoint.method, .get)
        XCTAssertEqual(endpoint.queryParameters?["per_page"], "100")
        XCTAssertEqual(endpoint.queryParameters?["since"], "1000")
        XCTAssertEqual(endpoint.headers?["Content-Type"], "application/json;charset=utf-8")
    }
}
