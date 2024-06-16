//
//  PostListViewModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit
import Combine
import Network

class PostListViewModel: ObservableObject {
    // Published properties to update UI
    @Published var postList: [Post] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Core Data manager instance
    var dataManager = CoreDataStack.shared
    
    // Combine-related properties
    private var cancellables = Set<AnyCancellable>()
    private var monitor: NWPathMonitor?
    
    init() {
        setupNetworkMonitor()
    }
    
    // Setup network monitor using NWPathMonitor
    private func setupNetworkMonitor() {
        monitor = NWPathMonitor()
    }
    
    // Fetch posts with albums and photos
    func fetchPostsWithAlbums(page: Int) {
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            if path.status == .satisfied {
                self.fetchPostsFromRemote(page: page)
            } else {
                self.fetchPostsFromCoreData()
            }
        }
        
        if monitor?.currentPath.status == .satisfied {
            self.fetchPostsFromRemote(page: page)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
    }
}

// MARK: - PostListService Extension for `PostListService`
extension PostListViewModel: PostListService {
    
    // Fetch posts from remote API
    private func fetchPostsFromRemote(page: Int) {
        self.isLoading = true
        
        fetchPosts(page: page)
            .flatMap { [weak self] (posts: [Post]) -> AnyPublisher<[Post], ErrorHandler> in
                guard let self = self else {
                    return Fail(error: ErrorHandler.unknownError(error: "Something went wrong!"))
                        .eraseToAnyPublisher()
                }
                
                let postPublishers: [AnyPublisher<Post, ErrorHandler>] = posts.map { post in
                    self.fetchAlbums(userId: "\(post.userId)")
                        .flatMap { albums -> AnyPublisher<Post, ErrorHandler> in
                            let albumPublishers: [AnyPublisher<Album, ErrorHandler>] = albums.map { album in
                                self.fetchPhotos(albumId: "\(album.id)")
                                    .map { photos in
                                        var albumWithPhotos = album
                                        albumWithPhotos.photos = photos
                                        return albumWithPhotos
                                    }
                                    .eraseToAnyPublisher()
                            }
                            return Publishers.MergeMany(albumPublishers).collect()
                                .map { albumsWithPhotos in
                                    var postWithAlbums = post
                                    postWithAlbums.album = albumsWithPhotos
                                    return postWithAlbums
                                }
                                .eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
                return Publishers.MergeMany(postPublishers).collect().eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] posts in
                guard let self = self else { return }
                
                self.postList = posts
                self.savePostsWithAlbumsAndPhotos(posts: posts)  // comment when performing `UITests`
            })
            .store(in: &cancellables)
    }
}

// MARK: - PostListService Extension for `CoreData`
extension PostListViewModel {
    
    // Fetch posts from Core Data
    private func fetchPostsFromCoreData() {
        self.isLoading = true
        dataManager.fetchPostEntities()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] posts in
                guard let self = self else { return }
                
                self.postList = posts.map { Post(entity: $0) }
            })
            .store(in: &cancellables)
    }
    
    // Save posts with albums and photos to Core Data
    private func savePostsWithAlbumsAndPhotos(posts: [Post]) {
        
        let context = dataManager.context
        
        posts.forEach { post in
            let postEntity = PostEntity(context: context)
            postEntity.id = Int32(post.id)
            postEntity.userId = Int32(post.userId)
            postEntity.title = post.title
            postEntity.body = post.body
            
            if let postAlbums = post.album {
                let albumEntities = postAlbums.map { album in
                    let albumEntity = AlbumEntity(context: context)
                    albumEntity.id = Int32(album.id)
                    albumEntity.userId = Int32(album.userId)
                    albumEntity.title = album.title
                    albumEntity.post = postEntity
                    
                    if let albumPhotos = album.photos {
                        let photoEntities = albumPhotos.map { photo in
                            let photoEntity = PhotoEntity(context: context)
                            photoEntity.id = Int32(photo.id)
                            photoEntity.albumId = Int32(photo.albumId)
                            photoEntity.title = photo.title
                            photoEntity.url = photo.url
                            photoEntity.thumbnailUrl = photo.thumbnailUrl
                            photoEntity.album = albumEntity
                            return photoEntity
                        }
                        albumEntity.photos = NSSet(array: photoEntities)
                    }
                    return albumEntity
                }
                postEntity.albums = NSSet(array: albumEntities)
            }
        }
        
        CoreDataStack.shared.saveContext()
    }
}
