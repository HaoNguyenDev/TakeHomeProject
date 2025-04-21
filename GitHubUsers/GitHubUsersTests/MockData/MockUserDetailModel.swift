//
//  MockUserDetailModel.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 21/4/25.
//

import Foundation
@testable import GitHubUsers

class MockUserDetailModel {
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
