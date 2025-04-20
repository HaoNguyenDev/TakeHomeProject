//
//  UserItemModel.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 18/4/25.
//

import UIKit

// MARK: - Cacheable
/* custom model for ItemView then we can reuse */
struct UserItemModel {
    let id: Int?
    let userName: String?
    let avatarUrl: String?
    let githubUrl: String?
    let locationName: String?
    let followersCount: String?
    let followingCount: String?
    let blogUrl: String?
    let cachedImage: Data?
}
