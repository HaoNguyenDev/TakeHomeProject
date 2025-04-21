//
//  AppSetting.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 21/4/25.
//

import Foundation

final class AppSetting {
    static let shared = AppSetting()
    private init() {}
    
    var cacheExpirationTime: TimeInterval = 300 // seconds
}
