//
//  Item+CoreDataProperties.swift
//  tummoc
//
//  Created by nav on 26/07/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var icon: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var isBookmarked: Bool
    @NSManaged public var isAddedToCart: Bool
    @NSManaged public var relationship: Categories?

}

extension Item : Identifiable {

}
