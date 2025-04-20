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

extension UserListViewModel {
    // MARK: - Fetch new user
    func fetchUsers() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            let cachedUsers = try cacheService.fetchDataFromCache()
            if !cachedUsers.isEmpty {
                users = cachedUsers
                updatePagination(from: users)
                isLoading = false
                return
            }
        
            /* get new data from api */
            let newUsers = try await self.networkService.fetchUsers(perPage: paginationConfig.perPage,
                                                                    since: paginationConfig.since)
            /* just delete expired data until we have new data */
            if !newUsers.isEmpty {
                /* delete the expired data */
                try cacheService.clearExpiredDataFromCache()
                updatePagination(from: newUsers)
                users = newUsers
                /* cache all users again to make sure we have full user list after relaunch */
                try await cacheService.saveDataToCache(items: users)
            }
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            #if DEBUG
            print("Failed to fetch users: \(error.localizedDescription)")
            #endif
        }
    }
    
    // MARK: - LoadMore
    func loadMoreUser() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            /* get new data from api */
            let newUsers = try await self.networkService.fetchUsers(perPage: paginationConfig.perPage,
                                                                    since: paginationConfig.since)
             /* cache users and images */
            try await cacheService.saveDataToCache(items: newUsers)
            updatePagination(from: newUsers)
            self.users.append(contentsOf: newUsers)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    /* update since paramer with last user id */
    func updatePagination(from users: [User]) {
        if let lastUserId = users.last?.id {
            paginationConfig.since = lastUserId
        }
    }
}
