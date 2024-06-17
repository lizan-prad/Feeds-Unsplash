//
//  PictureModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

struct PictureModel: Codable {
    var id : String?
    var created_at : String?
    var updated_at : String?
    var width : Int?
    var height : Int?
    var color : String?
    var descriptions : String?
    var alt_description : String?
    var urls : Urls?
    var links : Links?
    var categories : [String]?
    var likes : Int?
    var liked_by_user : Bool?
    var current_user_collections : [String]?
    var user : User?
    var imageData: Data?
}

extension PictureModel {
    // Custom initializer to create PictureModel from PictureEntity
    init(entity: PictureEntity) {
        self.id = entity.id
        self.updated_at = entity.updatedAt
        self.width = Int(entity.width)
        self.height = Int(entity.height)
        self.color = entity.color
        self.descriptions = entity.descriptions
        self.alt_description = entity.altDescription
        self.likes = Int(entity.likes)
        self.liked_by_user = entity.likedByUser
        self.imageData = entity.imageData
        
        if let urlEntity = entity.url {
            self.urls = Urls(entity: urlEntity)
        }
        
        if let linkEntity = entity.links {
            self.links = Links(entity: linkEntity)
        }
        
        if let userEntity = entity.user {
            self.user = User(entity: userEntity)
        }
    }
}
