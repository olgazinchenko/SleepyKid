//
//  SleepEntity+CoreDataProperties.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 12/05/2024.
//
//

import Foundation
import CoreData


extension SleepEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SleepEntity> {
        return NSFetchRequest<SleepEntity>(entityName: "SleepEntity")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var sleepID: UUID
    @NSManaged public var kid: KidEntity?

}

extension SleepEntity : Identifiable {

}
