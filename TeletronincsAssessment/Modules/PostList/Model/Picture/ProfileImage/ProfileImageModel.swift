//
//  ProfileImageModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 17/06/2024.
//

import Foundation

struct ProfileImage : Codable {
    var id: String?
    var small : String?
    var medium : String?
    var large : String?
    
    init(entity: ProfileImageEntity) {
            self.id = entity.id
            self.small = entity.small
            self.medium = entity.medium
            self.large = entity.large
        }
}
