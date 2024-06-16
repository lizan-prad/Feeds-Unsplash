//
//  PostEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 16/06/2024.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var userId: Int32
    @NSManaged public var albums: NSSet?

}

// MARK: Generated accessors for albums
extension PostEntity {

    @objc(addAlbumsObject:)
    @NSManaged public func addToAlbums(_ value: AlbumEntity)

    @objc(removeAlbumsObject:)
    @NSManaged public func removeFromAlbums(_ value: AlbumEntity)

    @objc(addAlbums:)
    @NSManaged public func addToAlbums(_ values: NSSet)

    @objc(removeAlbums:)
    @NSManaged public func removeFromAlbums(_ values: NSSet)

}
