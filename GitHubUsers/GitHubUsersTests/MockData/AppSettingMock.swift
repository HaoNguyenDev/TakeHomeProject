//
//  AppSettingMock.swift
//  GitHubUsersTests
//
//  Created by Hao Nguyen on 24/4/25.
//
import Foundation
@testable import GitHubUsers

class AppSettingMock: AppSettingProtocol {
    var cacheExpirationTime: TimeInterval = 10
    init() {}
}
