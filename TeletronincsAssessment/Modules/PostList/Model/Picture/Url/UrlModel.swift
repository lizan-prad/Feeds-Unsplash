//
//  UrlModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

struct Urls : Codable {
    var id: String?
    var raw : String?
    var full : String?
    var regular : String?
    var small : String?
    var thumb : String?
    
    // Custom initializer to create Urls from UrlEntity
    init(entity: UrlEntity) {
        self.id = entity.id
        self.raw = entity.raw
        self.full = entity.full
        self.regular = entity.regular
        self.small = entity.small
        self.thumb = entity.thumb
    }
    
}
