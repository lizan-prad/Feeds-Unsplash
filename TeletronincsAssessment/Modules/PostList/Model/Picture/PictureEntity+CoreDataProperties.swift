//
//  PictureEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 17/06/2024.
//
//

import Foundation
import CoreData


extension PictureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PictureEntity> {
        return NSFetchRequest<PictureEntity>(entityName: "PictureEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var width: Int32
    @NSManaged public var height: Int32
    @NSManaged public var color: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var altDescription: String?
    @NSManaged public var likes: Int32
    @NSManaged public var likedByUser: Bool
    @NSManaged public var imageData: Data?
    @NSManaged public var url: UrlEntity?
    @NSManaged public var links: LinkEntity?
    @NSManaged public var user: UserEntity?

}
