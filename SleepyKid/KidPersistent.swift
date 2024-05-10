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
        
    }
    
    static func deleteKid(_ kid: Kid) {
        
    }
    
    static func fetchAll() -> [Kid] {
        return []
    }
}
