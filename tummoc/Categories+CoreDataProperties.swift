//
//  Categories+CoreDataProperties.swift
//  tummoc
//
//  Created by nav on 26/07/24.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Categories {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Item)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Item)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}

extension Categories : Identifiable {

}
