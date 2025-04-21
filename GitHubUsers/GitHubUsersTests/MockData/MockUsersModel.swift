//
//  MockUsersModel.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import Foundation
@testable import GitHubUsers

class MockUsersModel {
    static var mockSingleUser: User {
        return mockUserArray.first!
    }
    
    static var mockEmptyUserArray: [User] = []
    
    
    static var mockUserArray: [User] = {
        // Mock JSON data representing an array of users
        let jsonString = """
        [
          {
            "login": "jvantuyl",
            "id": 1,
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "url": "https://api.github.com/users/jvantuyl",
          },
          {
            "login": "BrianTheCoder",
            "id": 2,
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "url": "https://api.github.com/users/BrianTheCoder",
          },
          {
            "login": "freeformz",
            "id": 3,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "url": "https://api.github.com/users/freeformz",
          },
          {
            "login": "hassox",
            "id": 4,
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "url": "https://api.github.com/users/hassox",
          },
          {
            "login": "automatthew",
            "id": 5,
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "url": "https://api.github.com/users/automatthew",
          }
        ]
        """
        
        // Convert JSON string to Data and decode into [User]
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: jsonData)
            return users
        } catch {
            print("Error decoding mock user data: \(error)")
            return []
        }
    }()
    
    static var mockLoadMoreUserArray: [User] = {
        // Mock JSON data representing an array of users
        let jsonString = """
        [
          {
            "login": "regrereg",
            "id": 6,
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "url": "https://api.github.com/users/jvantuyl",
          },
          {
            "login": "dfdfgdfs",
            "id": 7,
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "url": "https://api.github.com/users/BrianTheCoder",
          },
          {
            "login": "eytytre",
            "id": 8,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "url": "https://api.github.com/users/freeformz",
          },
          {
            "login": "gfdsgfdgr",
            "id": 9,
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "url": "https://api.github.com/users/hassox",
          },
          {
            "login": "hgfsdhgfg",
            "id": 10,
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "url": "https://api.github.com/users/automatthew",
          }
        ]
        """
        
        // Convert JSON string to Data and decode into [User]
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: jsonData)
            return users
        } catch {
            print("Error decoding mock user data: \(error)")
            return []
        }
    }()
    
   
}

//MARK: - Mock Json Data
extension MockUsersModel {
    static var mockUserArrayJsonData: Data = {
        let jsonString = """
        [
          {
            "login": "jvantuyl",
            "id": 1,
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "url": "https://api.github.com/users/jvantuyl",
          },
          {
            "login": "BrianTheCoder",
            "id": 2,
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "url": "https://api.github.com/users/BrianTheCoder",
          },
          {
            "login": "freeformz",
            "id": 3,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "url": "https://api.github.com/users/freeformz",
          },
          {
            "login": "hassox",
            "id": 4,
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "url": "https://api.github.com/users/hassox",
          },
          {
            "login": "automatthew",
            "id": 5,
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "url": "https://api.github.com/users/automatthew",
          }
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        return jsonData
    }()
    
    static var mockLoadMoreUserJsonData: Data = {
        let jsonString = """
        [
          {
            "login": "regrereg",
            "id": 6,
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "url": "https://api.github.com/users/jvantuyl",
          },
          {
            "login": "dfdfgdfs",
            "id": 7,
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "url": "https://api.github.com/users/BrianTheCoder",
          },
          {
            "login": "eytytre",
            "id": 8,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "url": "https://api.github.com/users/freeformz",
          },
          {
            "login": "gfdsgfdgr",
            "id": 9,
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "url": "https://api.github.com/users/hassox",
          },
          {
            "login": "hgfsdhgfg",
            "id": 10,
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "url": "https://api.github.com/users/automatthew",
          }
        ]
        """
        let jsonData = jsonString.data(using: .utf8)!
        return jsonData
    }()
    
    static var mockUserEmptyJsonData: Data = {
        let jsonString = """
        []
        """
        let jsonData = jsonString.data(using: .utf8)!
        return jsonData
    }()
}
