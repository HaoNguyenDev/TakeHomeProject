//
//  User.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import Foundation
struct User: Codable, Identifiable {
    let login : String?
    let id : Int?
    let nodeId : String?
    let avatarUrl : String?
    let gravatarId : String?
    let url : String?
    let htmlUrl : String?
    let followersUrl : String?
    let followingUrl : String?
    let gistsUrl : String?
    let starredUrl : String?
    let subscriptionsUrl : String?
    let organizationsUrl : String?
    let reposUrl : String?
    let eventsUrl : String?
    let received_eventsUrl : String?
    let type : String?
    let userViewType : String?
    let siteAdmin : Bool?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case received_eventsUrl = "received_events_url"
        case type = "type"
        case userViewType = "user_view_type"
        case siteAdmin = "site_admin"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        nodeId = try values.decodeIfPresent(String.self, forKey: .nodeId)
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
        gravatarId = try values.decodeIfPresent(String.self, forKey: .gravatarId)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
        followersUrl = try values.decodeIfPresent(String.self, forKey: .followersUrl)
        followingUrl = try values.decodeIfPresent(String.self, forKey: .followingUrl)
        gistsUrl = try values.decodeIfPresent(String.self, forKey: .gistsUrl)
        starredUrl = try values.decodeIfPresent(String.self, forKey: .starredUrl)
        subscriptionsUrl = try values.decodeIfPresent(String.self, forKey: .subscriptionsUrl)
        organizationsUrl = try values.decodeIfPresent(String.self, forKey: .organizationsUrl)
        reposUrl = try values.decodeIfPresent(String.self, forKey: .reposUrl)
        eventsUrl = try values.decodeIfPresent(String.self, forKey: .eventsUrl)
        received_eventsUrl = try values.decodeIfPresent(String.self, forKey: .received_eventsUrl)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        userViewType = try values.decodeIfPresent(String.self, forKey: .userViewType)
        siteAdmin = try values.decodeIfPresent(Bool.self, forKey: .siteAdmin)
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
            "node_id": "MDQ6VXNlcjEwMQ==",
            "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/jvantuyl",
            "html_url": "https://github.com/jvantuyl",
            "followers_url": "https://api.github.com/users/jvantuyl/followers",
            "following_url": "https://api.github.com/users/jvantuyl/following{/other_user}",
            "gists_url": "https://api.github.com/users/jvantuyl/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/jvantuyl/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/jvantuyl/subscriptions",
            "organizations_url": "https://api.github.com/users/jvantuyl/orgs",
            "repos_url": "https://api.github.com/users/jvantuyl/repos",
            "events_url": "https://api.github.com/users/jvantuyl/events{/privacy}",
            "received_events_url": "https://api.github.com/users/jvantuyl/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "BrianTheCoder",
            "id": 102,
            "node_id": "MDQ6VXNlcjEwMg==",
            "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/BrianTheCoder",
            "html_url": "https://github.com/BrianTheCoder",
            "followers_url": "https://api.github.com/users/BrianTheCoder/followers",
            "following_url": "https://api.github.com/users/BrianTheCoder/following{/other_user}",
            "gists_url": "https://api.github.com/users/BrianTheCoder/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/BrianTheCoder/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/BrianTheCoder/subscriptions",
            "organizations_url": "https://api.github.com/users/BrianTheCoder/orgs",
            "repos_url": "https://api.github.com/users/BrianTheCoder/repos",
            "events_url": "https://api.github.com/users/BrianTheCoder/events{/privacy}",
            "received_events_url": "https://api.github.com/users/BrianTheCoder/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "freeformz",
            "id": 103,
            "node_id": "MDQ6VXNlcjEwMw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/103?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/freeformz",
            "html_url": "https://github.com/freeformz",
            "followers_url": "https://api.github.com/users/freeformz/followers",
            "following_url": "https://api.github.com/users/freeformz/following{/other_user}",
            "gists_url": "https://api.github.com/users/freeformz/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/freeformz/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/freeformz/subscriptions",
            "organizations_url": "https://api.github.com/users/freeformz/orgs",
            "repos_url": "https://api.github.com/users/freeformz/repos",
            "events_url": "https://api.github.com/users/freeformz/events{/privacy}",
            "received_events_url": "https://api.github.com/users/freeformz/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "hassox",
            "id": 104,
            "node_id": "MDQ6VXNlcjEwNA==",
            "avatar_url": "https://avatars.githubusercontent.com/u/104?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/hassox",
            "html_url": "https://github.com/hassox",
            "followers_url": "https://api.github.com/users/hassox/followers",
            "following_url": "https://api.github.com/users/hassox/following{/other_user}",
            "gists_url": "https://api.github.com/users/hassox/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/hassox/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/hassox/subscriptions",
            "organizations_url": "https://api.github.com/users/hassox/orgs",
            "repos_url": "https://api.github.com/users/hassox/repos",
            "events_url": "https://api.github.com/users/hassox/events{/privacy}",
            "received_events_url": "https://api.github.com/users/hassox/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "automatthew",
            "id": 105,
            "node_id": "MDQ6VXNlcjEwNQ==",
            "avatar_url": "https://avatars.githubusercontent.com/u/105?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/automatthew",
            "html_url": "https://github.com/automatthew",
            "followers_url": "https://api.github.com/users/automatthew/followers",
            "following_url": "https://api.github.com/users/automatthew/following{/other_user}",
            "gists_url": "https://api.github.com/users/automatthew/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/automatthew/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/automatthew/subscriptions",
            "organizations_url": "https://api.github.com/users/automatthew/orgs",
            "repos_url": "https://api.github.com/users/automatthew/repos",
            "events_url": "https://api.github.com/users/automatthew/events{/privacy}",
            "received_events_url": "https://api.github.com/users/automatthew/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "queso",
            "id": 106,
            "node_id": "MDQ6VXNlcjEwNg==",
            "avatar_url": "https://avatars.githubusercontent.com/u/106?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/queso",
            "html_url": "https://github.com/queso",
            "followers_url": "https://api.github.com/users/queso/followers",
            "following_url": "https://api.github.com/users/queso/following{/other_user}",
            "gists_url": "https://api.github.com/users/queso/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/queso/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/queso/subscriptions",
            "organizations_url": "https://api.github.com/users/queso/orgs",
            "repos_url": "https://api.github.com/users/queso/repos",
            "events_url": "https://api.github.com/users/queso/events{/privacy}",
            "received_events_url": "https://api.github.com/users/queso/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "lancecarlson",
            "id": 107,
            "node_id": "MDQ6VXNlcjEwNw==",
            "avatar_url": "https://avatars.githubusercontent.com/u/107?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/lancecarlson",
            "html_url": "https://github.com/lancecarlson",
            "followers_url": "https://api.github.com/users/lancecarlson/followers",
            "following_url": "https://api.github.com/users/lancecarlson/following{/other_user}",
            "gists_url": "https://api.github.com/users/lancecarlson/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/lancecarlson/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/lancecarlson/subscriptions",
            "organizations_url": "https://api.github.com/users/lancecarlson/orgs",
            "repos_url": "https://api.github.com/users/lancecarlson/repos",
            "events_url": "https://api.github.com/users/lancecarlson/events{/privacy}",
            "received_events_url": "https://api.github.com/users/lancecarlson/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
          },
          {
            "login": "drnic",
            "id": 108,
            "node_id": "MDQ6VXNlcjEwOA==",
            "avatar_url": "https://avatars.githubusercontent.com/u/108?v=4",
            "gravatar_id": "",
            "url": "https://api.github.com/users/drnic",
            "html_url": "https://github.com/drnic",
            "followers_url": "https://api.github.com/users/drnic/followers",
            "following_url": "https://api.github.com/users/drnic/following{/other_user}",
            "gists_url": "https://api.github.com/users/drnic/gists{/gist_id}",
            "starred_url": "https://api.github.com/users/drnic/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/drnic/subscriptions",
            "organizations_url": "https://api.github.com/users/drnic/orgs",
            "repos_url": "https://api.github.com/users/drnic/repos",
            "events_url": "https://api.github.com/users/drnic/events{/privacy}",
            "received_events_url": "https://api.github.com/users/drnic/received_events",
            "type": "User",
            "user_view_type": "public",
            "site_admin": false
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
