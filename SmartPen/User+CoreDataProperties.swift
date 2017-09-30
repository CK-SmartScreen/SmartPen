//
//  User+CoreDataProperties.swift
//  SmartPen
//
//  Created by CK on 27/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var agegroup: String?
    @NSManaged public var gender: String?
    @NSManaged public var occupation: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
}
