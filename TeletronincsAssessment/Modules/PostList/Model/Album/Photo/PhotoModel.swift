//
//  PhotoModel.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 16/06/2024.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

extension Photo {
    init(entity: PhotoEntity) {
        self.id = Int(entity.id)
        self.albumId = Int(entity.albumId)
        self.title = entity.title ?? ""
        self.url = entity.url ?? ""
        self.thumbnailUrl = entity.thumbnailUrl ?? ""
    }
}
