//
//  KidEntity+CoreDataProperties.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 12/05/2024.
//
//

import Foundation
import CoreData


extension KidEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KidEntity> {
        return NSFetchRequest<KidEntity>(entityName: "KidEntity")
    }

    @NSManaged public var birthDate: Date?
    @NSManaged public var kidID: UUID
    @NSManaged public var name: String?
    @NSManaged public var sleeps: NSSet?

}

// MARK: Generated accessors for sleeps
extension KidEntity {

    @objc(addSleepsObject:)
    @NSManaged public func addToSleeps(_ value: SleepEntity)

    @objc(removeSleepsObject:)
    @NSManaged public func removeFromSleeps(_ value: SleepEntity)

    @objc(addSleeps:)
    @NSManaged public func addToSleeps(_ values: NSSet)

    @objc(removeSleeps:)
    @NSManaged public func removeFromSleeps(_ values: NSSet)

}

extension KidEntity : Identifiable {

}
