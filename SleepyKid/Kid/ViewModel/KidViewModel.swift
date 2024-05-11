//
//  KidViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 02/05/2024.
//

import Foundation

protocol KidViewModelProtocol {
    var kid: Kid? { get set }
    var isNewKid: Bool { get set }
    
    func save(with name: String, and dateOfBirth: Date)
    func delete()
}

final class KidViewModel: KidViewModelProtocol {
    // MARK: - Properties
    var kid: Kid?
    var isNewKid: Bool = true
    
    // MARK: - Initialization
    init(kid: Kid?) {
        self.kid = kid
    }
    
    // MARK: - Methods
    func save(with name: String, and dateOfBirth: Date) {
        let kid = Kid(name: name,
                      dateOfBirth: dateOfBirth)
        KidPersistent.saveKid(kid)
    }
    
    func delete() {
        guard let kid = kid else { return }
        KidPersistent.deleteKid(kid)
    }
}
