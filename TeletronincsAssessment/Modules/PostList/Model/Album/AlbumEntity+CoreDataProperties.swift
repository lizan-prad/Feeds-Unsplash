//
//  AlbumEntity+CoreDataProperties.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//
//

import Foundation
import CoreData

extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: "AlbumEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var title: String?
    @NSManaged public var post: PostEntity?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension AlbumEntity {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoEntity)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoEntity)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension AlbumEntity : Identifiable {

}
