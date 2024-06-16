//
//  PhotoEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 15/06/2024.
//
//

import Foundation
import CoreData


extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var albumId: Int32
    @NSManaged public var id: Int32
    @NSManaged public var thumbnailUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var album: AlbumEntity?

}
