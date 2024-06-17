//
//  ProfileImageEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 17/06/2024.
//
//

import Foundation
import CoreData


extension ProfileImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileImageEntity> {
        return NSFetchRequest<ProfileImageEntity>(entityName: "ProfileImageEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var small: String?
    @NSManaged public var medium: String?
    @NSManaged public var large: String?

}
