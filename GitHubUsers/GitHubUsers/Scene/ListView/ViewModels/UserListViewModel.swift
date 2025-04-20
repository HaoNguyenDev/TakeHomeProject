//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import Foundation
import SwiftData
import UIKit

struct PaginationConfig {
    var perPage: Int
    var since: Int
}

// MARK: - UserListViewModel Protocol
protocol UserListViewModelProtocol {
    var users: [User] { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    func fetchUsers() async
    func loadMoreUser() async
    func updatePagination(from users: [User])
}

// MARK: - UserListViewModel
@MainActor
class UserListViewModel: ObservableObject, @preconcurrency UserListViewModelProtocol {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let networkService: GitHubServiceProtocol
    private let cacheService: CacheManager<User>
    private var paginationConfig: PaginationConfig
    
    init(networkService: GitHubServiceProtocol = GitHubNetworkService(),
         cacheService: CacheManager<User>,
         paginationConfig: PaginationConfig = PaginationConfig(perPage: 10, since: 0)) {
        self.networkService = networkService
        self.cacheService = cacheService
        self.paginationConfig = paginationConfig
    }
}

// MARK: - Public Methods
extension UserListViewModel {
    func fetchUsers() async {
        await performWithLoading {
            let cachedUsers = try fetchCachedUsers()
            if !cachedUsers.isEmpty {
                updateUsers(cachedUsers)
                updatePagination(from: cachedUsers)
                return
            }
            
            let newUsers = try await fetchUsersFromAPI()
            if !newUsers.isEmpty {
                try cacheService.clearExpiredDataFromCache()
                updateUsers(newUsers)
                updatePagination(from: newUsers)
                try await saveUsersToCache(newUsers)
            }
        }
    }
    
    func loadMoreUser() async {
        await performWithLoading {
            let newUsers = try await fetchUsersFromAPI()
            try await saveUsersToCache(newUsers)
            appendUsers(newUsers)
            updatePagination(from: newUsers)
        }
    }
    
    func updatePagination(from users: [User]) {
        if let lastUserId = users.last?.id {
            paginationConfig.since = lastUserId
        }
    }
}

// MARK: - Private Helper Methods
private extension UserListViewModel {
    private func performWithLoading(_ operation: () async throws -> Void) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            try await operation()
        } catch {
            self.error = error
            #if DEBUG
            print("Operation failed: \(error.localizedDescription)")
            #endif
        }
    }
    
    private func fetchCachedUsers() throws -> [User] {
        return try cacheService.fetchDataFromCache()
    }
    
    private func fetchUsersFromAPI() async throws -> [User] {
        return try await networkService.fetchUsers(
            perPage: paginationConfig.perPage,
            since: paginationConfig.since
        )
    }
    
    private func saveUsersToCache(_ users: [User]) async throws {
        try await cacheService.saveDataToCache(items: users)
    }
    
    private func updateUsers(_ newUsers: [User]) {
        self.users = newUsers
    }
    
    private func appendUsers(_ newUsers: [User]) {
        self.users.append(contentsOf: newUsers)
    }
}
