//
//  KidViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 02/05/2024.
//

import Foundation

protocol KidViewModelProtocol {
    var kid: Kid? { get set }
    var kidBirthDate: Date { get }
    var kidName: String { get }
    
    func save(with name: String, and dateOfBirth: Date)
    func delete()
}

final class KidViewModel: KidViewModelProtocol {
    // MARK: - Properties
    var kid: Kid?
    var kidBirthDate: Date {
        kid?.birthDate ?? .now
    }
    var kidName: String {
        kid?.name ?? ""
    }
    
    // MARK: - Initialization
    init(kid: Kid?) {
        self.kid = kid
    }
    
    // MARK: - Methods
    func save(with name: String, and dateOfBirth: Date) {
        let id = ((kid == nil) ? UUID() : kid?.id) ?? UUID()
        let kidToSave = Kid(id: id,
                            name: name,
                            birthDate: dateOfBirth,
                            sleeps: kid?.sleeps ?? [])
        KidPersistent.save(kidToSave)
    }
    
    func delete() {
        guard let kid = kid else { return }
        KidPersistent.deleteKid(kid)
    }
}
