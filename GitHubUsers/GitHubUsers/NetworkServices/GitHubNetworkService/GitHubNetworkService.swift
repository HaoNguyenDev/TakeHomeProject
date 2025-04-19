//
//  GitHubNetworkService.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import Foundation

protocol GitHubService {
    func fetchUsers(perPage: Int, since: Int) async throws -> [User]
    func fetchUserDetail(by username: String) async throws -> UserDetail
}

class GitHubNetworkService: GitHubService {
    private let networkManager: NetworkService
    
    init(networkManager: NetworkService = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchUsers(perPage: Int, since: Int) async throws -> [User] {
        let endpoint = GitHubAPIEndpoint.getUsersEndpoint(perPage: perPage, since: since)
        return try await networkManager.fetchData(endpoint: endpoint, responseType: [User].self)
    }
    
    func fetchUserDetail(by username: String) async throws -> UserDetail {
        let endpoint = GitHubAPIEndpoint.getUserDetailEndpoint(username: username)
        return try await networkManager.fetchData(endpoint: endpoint, responseType: UserDetail.self)
    }
}
