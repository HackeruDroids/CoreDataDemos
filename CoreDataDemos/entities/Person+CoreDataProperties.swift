//
//  Person+CoreDataProperties.swift
//  CoreDataDemos
//
//  Created by hackeru on 13 Heshvan 5778.
//  Copyright © 5778 hackeru. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var email: String
    @NSManaged public var image: NSData?

}
