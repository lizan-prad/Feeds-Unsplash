//
//  LinksModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

struct Links : Codable {
    var html : String?
    var photos : String?
    var likes : String?
    var portfolio : String?
    var following : String?
    var followers : String?
    
    // Custom initializer to create Links from LinkEntity
    init(entity: LinkEntity) {
        self.html = entity.html
        self.photos = entity.photos
        self.likes = entity.likes
        self.portfolio = entity.portfolio
        self.following = entity.following
        self.followers = entity.followers
    }
}
