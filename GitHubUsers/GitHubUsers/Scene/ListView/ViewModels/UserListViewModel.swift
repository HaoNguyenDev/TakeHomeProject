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
         paginationConfig: PaginationConfig = PaginationConfig(perPage: 20, since: 0)) {
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
                #if DEBUG
                print("Fetched users from cache")
                #endif
                /* clear cache if need */
                clearExpiredCacheIfNeeded()
                return
            }
            
            /* fetch new data if cache is empty */
            let newUsers = try await fetchUsersFromAPI()
            if !newUsers.isEmpty {
                /* save new data to cache */
                try await saveUsersToCache(newUsers)
                updateUsers(newUsers)
                updatePagination(from: newUsers)
                #if DEBUG
                print("Fetched users from server")
                #endif
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
    
    private func updateUsers(_ newUsers: [User]) {
        self.users = newUsers
    }
    
    private func appendUsers(_ newUsers: [User]) {
        self.users.append(contentsOf: newUsers)
    }
    
    private func saveUsersToCache(_ users: [User]) async throws {
        try await cacheService.saveDataToCache(items: users)
    }
    
    private func clearExpiredCacheIfNeeded() {
        do {
            try cacheService.clearExpiredDataFromCache()
        } catch {
            #if DEBUG
            print("Failed to clear expired cache: \(error)")
            #endif
        }
    }
}

//MARK: - SUPPORT UNIT TEST
#if DEBUG
extension UserListViewModel {
    var testPaginationConfig: PaginationConfig {
        return paginationConfig
    }
}
#endif
