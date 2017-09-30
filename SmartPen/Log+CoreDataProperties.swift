//
//  Log+CoreDataProperties.swift
//  SmartPen
//
//  Created by CK on 27/09/17.
//  Copyright © 2017 Chunkai Meng. All rights reserved.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var username: String?
    @NSManaged public var logintime: String?

}
