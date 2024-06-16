//
//  PostModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 16/06/2024.
//

import Foundation

struct Post: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    var album: [Album]?
}

extension Post {
    init(entity: PostEntity) {
        self.id = Int(entity.id)
        self.userId = Int(entity.userId)
        self.title = entity.title ?? ""
        self.body = entity.body ?? ""
        if let albumEntities = entity.albums?.allObjects as? [AlbumEntity] {
            self.album = albumEntities.map { Album(entity: $0) }
        } else {
            self.album = nil
        }
    }
}
