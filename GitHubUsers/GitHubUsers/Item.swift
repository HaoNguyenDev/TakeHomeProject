//
//  Item.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 17/4/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
