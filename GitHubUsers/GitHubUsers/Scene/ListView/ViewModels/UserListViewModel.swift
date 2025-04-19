//
//  UserListViewModel.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let networkService: GitHubService
    private var perPage = 0
    private var since: Int = 100
    
    init(networkService: GitHubService = GitHubNetworkService()) {
        self.networkService = networkService
    }
}

extension UserListViewModel {
    
    @MainActor
    func fetchUsers() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            isLoading = true
            perPage += 10
            since += (100 * perPage)
            let newUsers = try await self.networkService.fetchUsers(perPage: perPage, since: since)
            users.append(contentsOf: newUsers)
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            #if DEBUG
            print("Failed to fetch users: \(error)")
            #endif
        }
    }
    
}
