//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import SwiftUI
import SwiftData

@main
struct GitHubUsersApp: App {
    let container: SwiftDataContainer
    
    init() {
        do {
            self.container = try SwiftDataContainer()
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            let context = container.createContext()
            let viewModel = UserListViewModel(
                networkService: GitHubNetworkService(),
                cacheService: CacheManager<User>(modelType: User.self, context: context)
            )
            UserListView(viewModel: viewModel)
        }
    }
}
