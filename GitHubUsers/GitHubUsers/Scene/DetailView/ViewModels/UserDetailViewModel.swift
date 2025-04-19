//
//  UserDetailViewModel.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//
import Foundation

class UserDetailViewModel: ObservableObject {
    @Published var usersDetail: UserDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let networkService: GitHubService?
    
    init(networkService: GitHubService = GitHubNetworkService()) {
        self.networkService = networkService
    }
}

extension UserDetailViewModel {
    @MainActor
    func fetchUsers(by userName: String) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        Task(priority: .medium) {
            do {
                usersDetail = try await networkService?.fetchUserDetail(by: userName)
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
}
