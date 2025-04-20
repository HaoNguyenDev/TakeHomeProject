//
//  SwiftDataContainer.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 19/4/25.
//
import SwiftData
import Foundation

// MARK: - SwiftData Container Setup
struct SwiftDataContainer {
    let container: ModelContainer
    
    init() throws {
        let schema = Schema([User.self]) /* we can add more class model to cache data if need */
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        self.container = try ModelContainer(for: schema, configurations: [configuration])
    }
    
    func createContext() -> ModelContext {
        return ModelContext(container)
    }
}
