//
//  Users+CoreDataProperties.swift
//  
//
//  Created by Technology on 03/09/22.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var type: Int16
    @NSManaged public var id: String

}
