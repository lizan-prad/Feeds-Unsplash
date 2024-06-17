//
//  UserModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

struct User : Codable {
    var id : String?
    var updated_at : String?
    var username : String?
    var name : String?
    var first_name : String?
    var last_name : String?
    var twitter_username : String?
    var portfolio_url : String?
    var bio : String?
    var location : String?
    var links : Links?
    var profile_image : ProfileImage?
    var instagram_username : String?
    var total_collections : Int?
    var total_likes : Int?
    var total_photos : Int?
    var accepted_tos : Bool?
    
}

extension User {
    // Custom initializer to create User from UserEntity
    init(entity: UserEntity) {
        self.id = entity.id
        self.updated_at = entity.updatedAt
        self.username = entity.username
        self.name = entity.name
        self.first_name = entity.firstName
        self.last_name = entity.lastName
        self.twitter_username = entity.twitterUsername
        self.portfolio_url = entity.portfolioUrl
        self.bio = entity.bio
        self.location = entity.location
        self.links = entity.links.map { Links(entity: $0) }
        self.profile_image = entity.profileImage.map { ProfileImage(entity: $0) }
        self.instagram_username = entity.instagramUsername
        self.total_collections = Int(entity.totalCollections)
        self.total_likes = Int(entity.totalLikes)
        self.total_photos = Int(entity.totalPhotos)
        self.accepted_tos = entity.acceptedTos
    }
}
