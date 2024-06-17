//
//  PostListService.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import Foundation
import Combine

protocol PostListService {
    // Function to fetch posts for a given page
    func fetchPhotos(page: Int) -> AnyPublisher<[PictureModel], ErrorHandler>
    
    // Function to fetch posts for a given username
    func fetchPhotosWith(username: String) -> AnyPublisher<[PictureModel], ErrorHandler>

}

extension PostListService {
    // Default implementation of fetchPosts using NetworkManager
    func fetchPhotos(page: Int) -> AnyPublisher<[PictureModel], ErrorHandler> {
        return NetworkManager.shared.fetch(PictureModel.self, endpoint: "photos?client_id=\(Configuration.clientID)&page=\(page)")
    }
    
    func fetchPhotosWith(username: String) -> AnyPublisher<[PictureModel], ErrorHandler> {
        return NetworkManager.shared.fetch(PictureModel.self, endpoint: "users/\(username)/photos?client_id=\(Configuration.clientID)&per_page=50")
    }
}
