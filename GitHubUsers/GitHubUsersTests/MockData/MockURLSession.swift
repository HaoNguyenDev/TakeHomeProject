//
//  MockURLSession.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import XCTest
@testable import GitHubUsers

/* Protocol URLSession behavior */
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

/* Extend URLSession to conform to URLSessionProtocol */
extension URLSession: URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}

//MARK: - Mock URLSession
class MockURLSession: URLSessionProtocol { // we can't cannot be inherited directly URLSession
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = error {
            throw GitHubServiceError.networkError(error: error)
        }
        guard let response = response else {
            throw GitHubServiceError.invalidResponse(statusCode: 0)
        }
        return (data ?? Data(), response)
    }
}

//MARK: - Mock Endpoint
struct MockEndpoint: Endpoint {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryParameters: [String: String]?
    var headers: [String: String]?
}

class NetworkManagerForTest: NetworkService {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        let urlRequest = try createURLRequest(from: endpoint)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GitHubServiceError.invalidResponse(statusCode: 0)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return try decodeData(data, to: responseType)
        case 400..<500:
            throw GitHubServiceError.clientError(statusCode: httpResponse.statusCode)
        case 500..<600:
            throw GitHubServiceError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw GitHubServiceError.unknownError(statusCode: httpResponse.statusCode)
        }
    }
    
    private func createURLRequest(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(string: endpoint.baseURL + endpoint.path)
        if let queryParameters = endpoint.queryParameters {
            components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else {
            throw GitHubServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        endpoint.headers?.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
    
    private func decodeData<T: Decodable>(_ data: Data, to type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw GitHubServiceError.decodingError(error: error)
        }
    }
}
