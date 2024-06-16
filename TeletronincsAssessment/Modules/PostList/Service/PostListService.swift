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
    func fetchPosts(page: Int) -> AnyPublisher<[Post], ErrorHandler>
    
    // Function to fetch albums for a given user ID
    func fetchAlbums(userId: String) -> AnyPublisher<[Album], ErrorHandler>
    
    // Function to fetch photos for a given album ID
    func fetchPhotos(albumId: String) -> AnyPublisher<[Photo], ErrorHandler>
}

extension PostListService {
    // Default implementation of fetchPosts using NetworkManager
    func fetchPosts(page: Int) -> AnyPublisher<[Post], ErrorHandler> {
        return NetworkManager.shared.fetch(Post.self, endpoint: "/posts?page=\(page)")
    }
    
    // Default implementation of fetchAlbums using NetworkManager
    func fetchAlbums(userId: String) -> AnyPublisher<[Album], ErrorHandler> {
        return NetworkManager.shared.fetch(Album.self, endpoint: "/users/\(userId)/albums")
    }
    
    // Default implementation of fetchPhotos using NetworkManager
    func fetchPhotos(albumId: String) -> AnyPublisher<[Photo], ErrorHandler> {
        return NetworkManager.shared.fetch(Photo.self, endpoint: "/album/\(albumId)/photos")
    }
}
