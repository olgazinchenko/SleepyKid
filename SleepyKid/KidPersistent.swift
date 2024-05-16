//
//  KidPersistent.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 10/05/2024.
//

import CoreData
import Foundation

final class KidPersistent {
    // MARK: - Properties
    private static let context = AppDelegate.persistentContainer.viewContext
    
    // MARK: - Methods
    static func save(_ kid: Kid) {
        guard let description = NSEntityDescription.entity(forEntityName: "KidEntity",
                                                           in: context) else { return }
        
        if let existingEntity = getEntity(for: kid) {
            existingEntity.name = kid.name
            existingEntity.dateOfBirth = kid.dateOfBirth
            existingEntity.sleeps = NSSet(array: kid.sleeps)
        } else {
            let entity = KidEntity(entity: description,
                                   insertInto: context)
            entity.kidID = kid.id
            entity.name = kid.name
            entity.dateOfBirth = kid.dateOfBirth
            entity.sleeps = NSSet(array: kid.sleeps)
        }
 
        saveContext()
    }
    
    static func deleteKid(_ kid: Kid) {
        guard let entity = getEntity(for: kid) else { return }
        context.delete(entity)
        saveContext()
    }
    
    static func fetchAll() -> [Kid] {
        let request = KidEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            return convert(entities: objects)
        } catch let error {
            debugPrint("Fetch kids error: \(error)")
            return []
        }
    }
    
    static func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Update"),
                                        object: nil)
    }
    
    static func getEntity(for kid: Kid) -> KidEntity? {
        let request = KidEntity.fetchRequest()
        let predicate = NSPredicate(format: "kidID == %@", kid.id as NSUUID)
        request.predicate = predicate
        
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch let error {
            debugPrint("Fetch kids error: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Methods
    private static func convert(entities: [KidEntity]) -> [Kid] {
        let kids: [Kid] = entities.map { entity in
            let sleepsArray = (entity.sleeps?.allObjects as? [SleepEntity] ?? []).map { sleep in
                Sleep(id: sleep.sleepID,
                      startDate: sleep.startDate ?? .now,
                      endDate: sleep.endDate ?? .now,
                      sleepType: .unowned)
            }
            
            return Kid(id: entity.kidID,
                       name: entity.name ?? "",
                       dateOfBirth: entity.dateOfBirth ?? .now,
                       sleeps: sleepsArray)
        }
        
        return kids
    }
    
    private static func saveContext() {
        do {
            try context.save()
            postNotification()
        } catch let error {
            debugPrint("Save a kid error: \(error)")
        }
    }
}
