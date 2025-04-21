//
//  GitHubServiceError.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 19/4/25.
//

import Foundation

// MARK: - Custom NetworkError
enum GitHubServiceError: Error, Equatable {
    case invalidURL
    case invalidData
    case invalidResponse(statusCode: Int)
    case decodingError(error: Error)
    case networkError(error: Error)
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case unknownError(statusCode: Int)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidData:
            return "Invalid Data"
        case .invalidResponse(let statusCode):
            return "Invalid Response: \(statusCode)"
        case .clientError(let statusCode):
            return "Client Error: \(statusCode)"
        case .serverError(let statusCode):
            return "Server Error: \(statusCode)"
        case .decodingError(error: let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .networkError(error: let error):
            return "Network Error: \(error.localizedDescription)"
        case .unknownError(let statusCode):
            return "Unknown Error Code: \(statusCode)"
        }
    }
    
    //MARK: - Conform Equatable protocol to support UnitTest
    static func == (lhs: GitHubServiceError, rhs: GitHubServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.invalidData, .invalidData):
            return true
        case (.invalidResponse(let statusCode1), .invalidResponse(let statusCode2)):
            return statusCode1 == statusCode2
        case (.clientError(let statusCode1), .clientError(let statusCode2)):
            return statusCode1 == statusCode2
        case (.serverError(let statusCode1), .serverError(let statusCode2)):
            return statusCode1 == statusCode2
        case (.unknownError(let statusCode1), .unknownError(let statusCode2)):
            return statusCode1 == statusCode2
        case (.decodingError(let error1), .decodingError(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.networkError(let error1), .networkError(let error2)):
            return error1.localizedDescription == error2.localizedDescription
        default:
            return false
        }
    }
}
