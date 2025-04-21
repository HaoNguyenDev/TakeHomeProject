//
//  MockSwiftDataContainer.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import Foundation
import SwiftData
@testable import GitHubUsers

class MockSwiftDataContainer {
    let container: ModelContainer
    
    init() throws {
        let schema = Schema([GitHubUsers.User.self]) /* we can add more class model to cache data if need */
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
