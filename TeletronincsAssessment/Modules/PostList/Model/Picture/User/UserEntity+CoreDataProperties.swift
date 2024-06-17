//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 17/06/2024.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var username: String?
    @NSManaged public var name: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var twitterUsername: String?
    @NSManaged public var portfolioUrl: String?
    @NSManaged public var bio: String?
    @NSManaged public var location: String?
    @NSManaged public var instagramUsername: String?
    @NSManaged public var totalCollections: Int32
    @NSManaged public var totalLikes: Int32
    @NSManaged public var totalPhotos: Int32
    @NSManaged public var acceptedTos: Bool
    @NSManaged public var links: LinkEntity?
    @NSManaged public var profileImage: ProfileImageEntity?

}
