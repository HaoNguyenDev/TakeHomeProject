//
//  MockNetworkManager.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

// MARK: - MockNetworkManager
class MockNetworkManager: NetworkService {
    var mockResult: Result<Decodable, Error>?
    var capturedEndpoint: Endpoint?
    
    func fetchData<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        capturedEndpoint = endpoint
        
        guard let mockResult = mockResult else {
            throw GitHubServiceError.invalidData
        }
        
        switch mockResult {
        case .success(let data):
            guard let result = data as? T else {
                throw GitHubServiceError.decodingError(error: NSError(domain: "MockError", code: -1))
            }
            return result
        case .failure(let error):
            throw error
        }
    }
}

