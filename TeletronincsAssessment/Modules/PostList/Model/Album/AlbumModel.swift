//
//  AlbumModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 16/06/2024.
//

import Foundation

struct Album: Codable {
    let id: Int
    let userId: Int
    let title: String
    var photos: [Photo]?
}

extension Album {
    init(entity: AlbumEntity) {
        self.id = Int(entity.id)
        self.userId = Int(entity.userId)
        self.title = entity.title ?? ""
        if let photoEntities = entity.photos?.allObjects as? [PhotoEntity] {
            self.photos = photoEntities.map { Photo(entity: $0) }
        } else {
            self.photos = nil
        }
    }
}
