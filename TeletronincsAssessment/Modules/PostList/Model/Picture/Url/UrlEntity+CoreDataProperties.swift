//
//  UrlEntity+CoreDataProperties.swift
//  
//
//  Created by Lizan on 17/06/2024.
//
//

import Foundation
import CoreData


extension UrlEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UrlEntity> {
        return NSFetchRequest<UrlEntity>(entityName: "UrlEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var raw: String?
    @NSManaged public var full: String?
    @NSManaged public var regular: String?
    @NSManaged public var small: String?
    @NSManaged public var thumb: String?

}
