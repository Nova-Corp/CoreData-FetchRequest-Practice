//
//  UsersEntity+CoreDataProperties.swift
//  CoreData-FetchRequest-Practice
//
//  Created by Mac on 26/11/21.
//
//

import Foundation
import CoreData


extension UsersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersEntity> {
        return NSFetchRequest<UsersEntity>(entityName: "UsersEntity")
    }

    @NSManaged public var name: String?

}

extension UsersEntity : Identifiable {

}
