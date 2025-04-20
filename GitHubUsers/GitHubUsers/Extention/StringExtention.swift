//
//  ExtentionString.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
}
