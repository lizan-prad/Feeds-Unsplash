//
//  LinkEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 17/06/2024.
//
//

import Foundation
import CoreData


extension LinkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LinkEntity> {
        return NSFetchRequest<LinkEntity>(entityName: "LinkEntity")
    }
    
    @NSManaged public var html: String?
    @NSManaged public var photos: String?
    @NSManaged public var likes: String?
    @NSManaged public var portfolio: String?
    @NSManaged public var following: String?
    @NSManaged public var followers: String?

}
