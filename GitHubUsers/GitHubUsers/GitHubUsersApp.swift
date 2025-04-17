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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            UserListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
