//
//  NetworkManagerTests.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManagerForTest!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        networkManager = NetworkManagerForTest(session: mockSession)
    }
    
    override func tearDown() {
        networkManager = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchData_SuccessfulResponse() async throws {
        //  Given
        let jsonData = MockUsersModel.mockUserArrayJsonData
        let users = try JSONDecoder().decode([User].self, from: jsonData)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When
        let result: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
        
        // Then
        XCTAssertEqual(result, users)
    }
    
    func testFetchData_ClientError() async {
        //  Given
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 404,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When & Assert
        do {
            let _: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
            XCTFail("Should throw client error")
        } catch {
            guard let serviceError = error as? GitHubServiceError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(serviceError, .clientError(statusCode: 404))
        }
    }
    
    func testFetchData_ServerError() async {
        //  Given
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 500,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When & Assert
        do {
            let _: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
            XCTFail("Should throw server error")
        } catch {
            guard let serviceError = error as? GitHubServiceError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(serviceError, .serverError(statusCode: 500))
        }
    }
    
    func testFetchData_InvalidURL() async {
        //  Given
        let endpoint = MockEndpoint(
            baseURL: "invalid_url",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When & Assert
        do {
            let _: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
            XCTFail("Should throw invalid URL error")
        } catch {
            guard let serviceError = error as? GitHubServiceError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(serviceError, .invalidResponse(statusCode: 0))
        }
    }
    
    func testFetchData_DecodingError() async {
        //  Given
        let invalidData = "invalid json".data(using: .utf8)!
        mockSession.data = invalidData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When & Assert
        do {
            let _: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
            XCTFail("Should throw decoding error")
        } catch {
            guard case GitHubServiceError.decodingError = error else {
                XCTFail("Expected decoding error")
                return
            }
        }
    }
    
    func testFetchData_WithQueryParameters() async throws {
        //  Given
        let jsonData = MockUsersModel.mockUserArrayJsonData
        let users = try JSONDecoder().decode([User].self, from: jsonData)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: ["since": "0"],
            headers: nil
        )
        
        // When
        let result: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
        
        // Then
        XCTAssertEqual(result, users)
    }
    
    func testFetchData_EmptyResponse() async throws {
        //  Given
        let jsonData = MockUsersModel.mockUserEmptyJsonData
        let users = try JSONDecoder().decode([User].self, from: jsonData)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: nil,
            headers: nil
        )
        
        // When
        let result: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
        
        // Then
        XCTAssertEqual(result, users)
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFetchData_LoadMoreUsers() async throws {
        //  Given
        let jsonData = MockUsersModel.mockLoadMoreUserJsonData
        let users = try JSONDecoder().decode([User].self, from: jsonData)
        mockSession.data = jsonData
        mockSession.response = HTTPURLResponse(url: URL(string: "https://api.github.com")!,
                                             statusCode: 200,
                                             httpVersion: nil,
                                             headerFields: nil)
        
        let endpoint = MockEndpoint(
            baseURL: "https://api.github.com",
            path: "/users",
            method: .get,
            queryParameters: ["since": "5"],
            headers: nil
        )
        
        // When
        let result: [User] = try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
        
        // Then
        XCTAssertEqual(result, users)
        XCTAssertEqual(result.count, 5)
        XCTAssertEqual(result.first?.id, 6)
    }
}
