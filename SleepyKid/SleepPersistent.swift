//
//  SleepPersistent.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 14/05/2024.
//

import CoreData
import Foundation

final class SleepPersistent {
    private static let context = AppDelegate.persistentContainer.viewContext
    
    static func save(_ sleep: Sleep, for kid: Kid) {
        guard let description = NSEntityDescription.entity(forEntityName: "SleepEntity",
                                                           in: context) else { return }
        if let existingEntity = getEntity(for: sleep) {
            existingEntity.startDate = sleep.startDate
            existingEntity.endDate = sleep.endDate
            existingEntity.kid = KidPersistent.getEntity(for: kid)
        } else {
            let entity = SleepEntity(entity: description,
                                   insertInto: context)
            entity.sleepID = sleep.id
            entity.startDate = sleep.startDate
            entity.endDate = sleep.endDate
            entity.kid = KidPersistent.getEntity(for: kid)
        }
 
        saveContext()
    }
    
    // TODO: fetch sleeps by a kid
    static func fetchAll() -> [Sleep] {
        let request = SleepEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            return convert(entities: objects)
        } catch let error {
            debugPrint("Fetch sleeps error: \(error)")
            return []
        }
    }
    
    // MARK: - Private Methods
    private static func getEntity(for sleep: Sleep) -> SleepEntity? {
        let request = SleepEntity.fetchRequest()
        let predicate = NSPredicate(format: "sleepID == %@", sleep.id as NSUUID)
        request.predicate = predicate
        
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch let error {
            debugPrint("Fetch sleeps error: \(error)")
            return nil
        }
    }
    
    private static func convert(entities: [SleepEntity]) -> [Sleep] {
        let sleeps: [Sleep] = entities.map { sleep in
            Sleep(id: sleep.sleepID,
                  startDate: sleep.startDate ?? .now,
                  endDate: sleep.endDate ?? .now,
                  sleepType: .unowned,
                  isNewSleep: false)
        }
        return sleeps
    }
    
    private static func saveContext() {
        do {
            try context.save()
            // TODO: postNotification()
        } catch let error {
            debugPrint("Save a sleep error: \(error)")
        }
    }
}
