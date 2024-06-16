//
//  ImageManager.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine

class ImageManager {
    
    static let shared = ImageManager()
    
    // Cache for storing images
    private let cache = NSCache<NSURL, UIImage>()
    
    private var cancellables = Set<AnyCancellable>()
    
    // Function to load image from URL
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        // Check if image is already cached
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return Just(cachedImage).eraseToAnyPublisher()
        }
        
        // Create a data task publisher for the URL session
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data  // Return data if successful
            }
            .map { UIImage(data: $0) }  // Convert data to UIImage
            .handleEvents(receiveOutput: { [weak self] image in
                // Cache the image if not nil
                if let image = image {
                    self?.cache.setObject(image, forKey: url as NSURL)
                }
            })
            .catch { error -> Just<UIImage?> in
                // Handle errors by returning nil image
                print("Failed to load image:", error.localizedDescription)
                return Just(UIImage(systemName: "photo.circle.fill"))
            }
            .receive(on: DispatchQueue.main)  // Receive on main thread for UI updates
            .eraseToAnyPublisher()  // Type-erase publisher to hide implementation details
    }
}
