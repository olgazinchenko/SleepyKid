//
//  KidEntity+CoreDataProperties.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 10/05/2024.
//
//

import Foundation
import CoreData


extension KidEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidEntity> {
        return NSFetchRequest<KidEntity>(entityName: "KidEntity")
    }

    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var name: String?

}

extension KidEntity : Identifiable {

}
