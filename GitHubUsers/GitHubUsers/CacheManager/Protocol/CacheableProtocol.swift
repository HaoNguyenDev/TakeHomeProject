//
//  CacheableProtocol.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 19/4/25.
//

import Foundation
import SwiftData

// MARK: - Cacheable 
protocol Cacheable: PersistentModel {
    var cachedAt: Date { get set }
    var imageURL: String? { get set }
    var cachedImage: Data? { get set }
}

//protocol ImageCacheable: Cacheable {
//    var imageURL: String? { get set }
//    var cachedImage: Data? { get set }
//}
