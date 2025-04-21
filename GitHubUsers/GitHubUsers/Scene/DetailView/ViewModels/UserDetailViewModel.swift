//
//  UserDetailViewModel.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//
import Foundation

// MARK: - UserDetailViewModel Protocol
protocol UserDetailViewModelProtocol {
    var usersDetail: UserDetail? { get }
    var isLoading: Bool { get }
    var error: Error? { get }
    func fetchUsers(by userName: String) async
}

// MARK: - UserDetailViewModel
class UserDetailViewModel: ObservableObject, UserDetailViewModelProtocol {
    @Published var usersDetail: UserDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    private let networkService: GitHubServiceProtocol?
    
    init(networkService: GitHubServiceProtocol = GitHubNetworkService()) {
        self.networkService = networkService
    }
}

extension UserDetailViewModel {
    @MainActor
    func fetchUsers(by userName: String) async {
        guard !isLoading else { return }
        guard let networkService = networkService else {
            error = NSError(domain: "UserDetailViewModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network service is not available"])
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            let userDetail = try await networkService.fetchUserDetail(by: userName)
            self.usersDetail = userDetail
        } catch {
            self.error = error
            #if DEBUG
            print("Failed to fetch user detail: \(error)")
            #endif
        }
        
        isLoading = false
    }
}
