//
//  UserDetail.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import Foundation

// MARK: - UserDetailModel
struct UserDetail: Codable {
    let login : String?
    let name: String?
    let id : Int?
    let avatarUrl : String?
    let url : String?
    let htmlUrl : String?
    let location : String?
    let followers : Int?
    let following : Int?
    let blog : String?
    
    enum CodingKeys: String, CodingKey {
        
        case login = "login"
        case name = "name"
        case id = "id"
        case avatarUrl = "avatar_url"
        case url = "url"
        case htmlUrl = "html_url"
        case location = "location"
        case followers = "followers"
        case following = "following"
        case blog = "blog"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        followers = try values.decodeIfPresent(Int.self, forKey: .followers)
        following = try values.decodeIfPresent(Int.self, forKey: .following)
        blog = try values.decodeIfPresent(String.self, forKey: .blog)
    }
    
    init() {
        login = ""
        name = ""
        id = 0
        avatarUrl = ""
        url = ""
        htmlUrl = ""
        location = ""
        followers = 0
        following = 0
        blog = ""
    }
    
    func getUserFollowers() -> String {
        guard let followers = followers else {
            return "0"
        }
        return "\(followers)"
    }
    
    func getUserFollowing() -> String {
        guard let following = following else {
            return "0"
        }
        return "\(following)"
    }
}

// MARK: - MockData
extension UserDetail {
    static var mockUserDetail: UserDetail = {
        /* Mock JSON data representing an array of users */
        let jsonString = """
        {
          "login": "jvantuyl",
          "name": "Jayson Vantuyl",
          "id": 101,
          "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
          "url": "https://api.github.com/users/jvantuyl",
          "html_url": "https://github.com/jvantuyl",
          "location": "Plumas County, California, USA",
          "followers": 66,
          "following": 15,
          "blog": "http://souja.net",
        }
        """
        
        /* Convert JSON string to Data and decode into [User] */
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let decoder = JSONDecoder()
            let user = try decoder.decode(UserDetail.self, from: jsonData)
            return user
        } catch {
            #if DEBUG
            print("Error decoding mock user data: \(error)")
            #endif
            return UserDetail()
        }
    }()
}
