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
    @Published var pictureList: [[PictureModel]] = []
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
                self.fetchPhotos(page)
            } else {
                self.fetchPicturesFromCoreData()
            }
        }
        
        if monitor?.currentPath.status == .satisfied {
            self.fetchPhotos(page)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.start(queue: queue)
    }
}

// MARK: - PostListService Extension for `PostListService`
extension PostListViewModel: PostListService {
    
    func fetchPhotos(_ page: Int) {
        self.isLoading = true
        self.fetchPhotos(page: page)
            .flatMap { [weak self] (posts: [PictureModel]) -> AnyPublisher<[[PictureModel]], ErrorHandler> in
                guard let self = self else {
                    return Fail(error: ErrorHandler.unknownError(error: "Something went wrong!"))
                        .eraseToAnyPublisher()
                }
                
                let userPublishers: [AnyPublisher<[PictureModel], ErrorHandler>] = posts.map { model in
                    self.fetchPhotosWith(username: model.user?.username ?? "")
                }
                
                return Publishers.MergeMany(userPublishers).collect()
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break // handle successful completion if needed
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] picturesArray in
                self?.pictureList = (self?.pictureList ?? []) + picturesArray
                self?.savePictureModels(userPicturesList: picturesArray.flatMap({$0}))
            })
            .store(in: &cancellables)
    }
}

// MARK: - PostListService Extension for `CoreData`
extension PostListViewModel {
    
    // Fetch posts from Core Data
    private func fetchPicturesFromCoreData() {
        self.isLoading = true
        
        dataManager.fetchPictureEntities()
            .receive(on: DispatchQueue.main) // Ensure UI updates on the main thread
            .map { posts -> [PictureModel] in
                return posts.compactMap { PictureModel(entity: $0) }
            }
            .map { pictureModels -> [[PictureModel]] in
                // Group PictureModels by username
                return Dictionary(grouping: pictureModels) { $0.user?.username ?? "" }.values.map { $0 }
            }
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] pictureArray in
                self?.isLoading = false
                self?.pictureList = pictureArray
            })
            .store(in: &cancellables)
    }
    
    // Save posts with albums and photos to Core Data
    private func savePictureModels(userPicturesList: [PictureModel]) {
        let context = dataManager.context
        
        userPicturesList.forEach { userPicture in
            let pictureEntity = PictureEntity(context: context)
            
            pictureEntity.id = userPicture.id
            pictureEntity.updatedAt = userPicture.updated_at
            pictureEntity.width = Int32(userPicture.width ?? 0)
            pictureEntity.height = Int32(userPicture.height ?? 0)
            pictureEntity.color = userPicture.color
            pictureEntity.descriptions = userPicture.descriptions
            pictureEntity.altDescription = userPicture.alt_description
            pictureEntity.likes = Int32(userPicture.likes ?? 0)
            pictureEntity.likedByUser = userPicture.liked_by_user ?? false
            pictureEntity.imageData = userPicture.imageData
            
            // Create and set URL entity
            if let urls = userPicture.urls {
                let urlEntity = UrlEntity(context: context)
                urlEntity.raw = urls.raw
                urlEntity.full = urls.full
                urlEntity.regular = urls.regular
                urlEntity.small = urls.small
                urlEntity.thumb = urls.thumb
                pictureEntity.url = urlEntity
            }
            
            // Create and set links entity
            if let links = userPicture.links {
                let linkEntity = LinkEntity(context: context)
                linkEntity.html = links.html
                linkEntity.photos = links.photos
                linkEntity.likes = links.likes
                linkEntity.portfolio = links.portfolio
                linkEntity.following = links.following
                linkEntity.followers = links.followers
                pictureEntity.links = linkEntity
            }
            
            // Create and set user entity
            if let userModel = userPicture.user {
                let userEntity = UserEntity(context: context)
                userEntity.id = userModel.id
                userEntity.updatedAt = userModel.updated_at
                userEntity.username = userModel.username
                userEntity.name = userModel.name
                userEntity.firstName = userModel.first_name
                userEntity.lastName = userModel.last_name
                userEntity.twitterUsername = userModel.twitter_username
                userEntity.portfolioUrl = userModel.portfolio_url
                userEntity.bio = userModel.bio
                userEntity.location = userModel.location
                userEntity.instagramUsername = userModel.instagram_username
                userEntity.totalCollections = Int32(userModel.total_collections ?? 0)
                userEntity.totalLikes = Int32(userModel.total_likes ?? 0)
                userEntity.totalPhotos = Int32(userModel.total_photos ?? 0)
                userEntity.acceptedTos = userModel.accepted_tos ?? false
                
                // Set links entity for user
                if let links = userModel.links {
                    let userLinkEntity = LinkEntity(context: context)
                    userLinkEntity.html = links.html
                    userLinkEntity.photos = links.photos
                    userLinkEntity.likes = links.likes
                    userLinkEntity.portfolio = links.portfolio
                    userLinkEntity.following = links.following
                    userLinkEntity.followers = links.followers
                    userEntity.links = userLinkEntity
                }
                
                // Set profile image entity for user
                if let profileImage = userModel.profile_image {
                    let userProfileImageEntity = ProfileImageEntity(context: context)
                    userProfileImageEntity.small = profileImage.small
                    userProfileImageEntity.medium = profileImage.medium
                    userProfileImageEntity.large = profileImage.large
                    userEntity.profileImage = userProfileImageEntity
                }
                
                pictureEntity.user = userEntity
            }
        }
        
        CoreDataStack.shared.saveContext()
    }
}
