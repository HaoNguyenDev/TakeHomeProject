//
//  AppSetting.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 21/4/25.
//

import Foundation

protocol AppSettingProtocol {
    var cacheExpirationTime: TimeInterval { get }
}

final class AppSetting: AppSettingProtocol {
    static let shared = AppSetting()
    private init() {}
    
    var cacheExpirationTime: TimeInterval = 300 // seconds
}
