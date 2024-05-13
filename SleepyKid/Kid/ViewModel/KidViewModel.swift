//
//  KidViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 02/05/2024.
//

import Foundation

protocol KidViewModelProtocol {
    var kid: Kid? { get set }
    
    func saveKid(id: UUID?,
                 name: String,
                 dateOfBirth: Date,
                 isNewKid: Bool,
                 sleeps: [Sleep])
    func delete()
}

final class KidViewModel: KidViewModelProtocol {
    // MARK: - Properties
    var kid: Kid?
    
    // MARK: - Initialization
    init(kid: Kid?) {
        self.kid = kid
    }
    
    // MARK: - Methods
    func saveKid(id: UUID?,
                 name: String,
                 dateOfBirth: Date,
                 isNewKid: Bool,
                 sleeps: [Sleep]) {
        let id = id != nil ? id : UUID()
        let kid = Kid(id: id,
                      name: name,
                      dateOfBirth: dateOfBirth,
                      sleeps: sleeps, 
                      isNewKid: false)
        KidPersistent.saveKid(kid)
    }
    
    func delete() {
        guard let kid = kid else { return }
        KidPersistent.deleteKid(kid)
    }
}
