//
//  ImageLoader.swift
//  GitHubUsers
//
//  Created by Hao Nguyen on 20/4/25.
//

import Foundation
import UIKit

// MARK: - ImageLoaderProtocol
protocol ImageLoaderProtocol {
    associatedtype T: Cacheable
    func loadImage(for model: T) async -> Data?
}

// MARK: - ImageLoader
class ImageLoader<T: Cacheable>: ImageLoaderProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadImage(for model: T) async -> Data? {
        guard let urlString = model.imageURL, let url = URL(string: urlString), model.cachedImage == nil else {
            return model.cachedImage
        }
        /* load image from url and resize reduce memory */
        do {
            let (data, _) = try await session.data(from: url)
            if let image = UIImage(data: data) {
                let resizedImage = image.resized(to: CGSize(width: 50, height: 50)) ?? image
                return resizedImage.pngData()
            }
            return nil
        } catch {
            #if DEBUG
            print("Failed to load image for \(model.imageURL.orEmpty): \(error)")
            #endif
            return nil
        }
    }
}
