//
//  SleepViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import Foundation


protocol SleepViewModelProtocol {
    var sleep: Sleep? { get set }
    var kid: Kid? { get set }
    
    func save(with startDate: Date, and endDate: Date)
    func delete()
}

final class SleepViewModel: SleepViewModelProtocol {
    // MARK: - Properties
    var sleep: Sleep?
    var kid: Kid?
    
    // MARK: Initialization
    init(sleep: Sleep?, kid: Kid?) {
        self.sleep = sleep
        self.kid = kid
    }
    
    // MARK: - Methods
    func save(with startDate: Date, and endDate: Date) {
        let id = ((sleep == nil) ? UUID() : sleep?.id) ?? UUID()
        let sleepToSave = Sleep(id: id,
                                startDate: startDate,
                                endDate: endDate,
                                sleepType: .unowned)
        SleepPersistent.save(sleepToSave, for: kid ?? Kid(id: UUID(),
                                                          name: "",
                                                          dateOfBirth: .now))
    }
    
    func delete() {
        guard let sleep = sleep else { return }
        SleepPersistent.deleteSleep(sleep)
    }
}
