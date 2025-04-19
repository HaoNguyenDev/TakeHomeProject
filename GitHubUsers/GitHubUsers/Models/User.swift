//
//  User.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import Foundation
struct User: Codable, Identifiable, Equatable {
    let id: Int?
    let login : String?
    let avatarUrl : String?
    let url : String?
   
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

//MockData
extension User {
    static var mockUserArray: [User] = {
        // Mock JSON data representing an array of users
        let jsonString = """
        [
          {
            "login": "jvantuyl",
            "id": 101,
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "url": "https://api.github.com/users/jvantuyl",
          },
          {
            "login": "BrianTheCoder",
            "id": 102,
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "url": "https://api.github.com/users/BrianTheCoder",
          },
          {
            "login": "freeformz",
            "id": 103,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "url": "https://api.github.com/users/freeformz",
          },
          {
            "login": "hassox",
            "id": 104,
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "url": "https://api.github.com/users/hassox",
          },
          {
            "login": "automatthew",
            "id": 105,
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "url": "https://api.github.com/users/automatthew",
          },
          {
            "login": "queso",
            "id": 106,
            "avatar_url": "https://avatars.githubusercontent.com/u/106?v=4",
            "url": "https://api.github.com/users/queso"
          },
          {
            "login": "lancecarlson",
            "id": 107,
            "avatar_url": "https://avatars.githubusercontent.com/u/107?v=4",
            "url": "https://api.github.com/users/lancecarlson",
          },
          {
            "login": "drnic",
            "id": 108,
            "avatar_url": "https://avatars.githubusercontent.com/u/108?v=4",
            "url": "https://api.github.com/users/drnic",
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
    
    static var singleUser: User {
        return mockUserArray.first!
    }
}
