//
//  SwiftDataContainer.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 19/4/25.
//
import SwiftData

// MARK: - SwiftData Container Setup
struct SwiftDataContainer {
    /* ModelContainer manage data for SwiftData */
    let container: ModelContainer
    
    init() throws {
        /* we can add more class model to Schema (cache data) if need */
        let schema = Schema([User.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        /* if true then data save on ram and reset when close app */
        
        self.container = try ModelContainer(for: schema, configurations: [configuration])
    }
    
    /* ModelContext is where operations such as adding, deleting, and editing data are performed.*/
    func createContext() -> ModelContext {
        return ModelContext(container)
    }
}
