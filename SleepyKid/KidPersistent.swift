//
//  KidPersistent.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 10/05/2024.
//

import CoreData
import Foundation

final class KidPersistent {
    private static let context = AppDelegate.persistentContainer.viewContext
    
    static func saveKid(_ kid: Kid) {
        guard let description = NSEntityDescription.entity(forEntityName: "KidEntity",
                                                           in: context) else { return }
        let entity = KidEntity(entity: description,
                               insertInto: context)
        
        entity.name = kid.name
        entity.dateOfBirth = kid.dateOfBirth
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
    
    // MARK: - Private Methods
    private static func convert(entities: [KidEntity]) -> [Kid] {
        let kids = entities.map {
            Kid(name: $0.name ?? "",
                dateOfBirth: $0.dateOfBirth ?? .now)
        }
        
        return kids
    }
    
    private static func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("Update"), 
                                        object: nil)
    }
    
    private static func getEntity(for kid: Kid) -> KidEntity? {
        let request = KidEntity.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", kid.name as String)
        request.predicate = predicate
        
        do {
            let objects = try context.fetch(request)
            return objects.first
        } catch let error {
            debugPrint("Fetch kids error: \(error)")
            return nil
        }
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
