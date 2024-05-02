//
//  KidsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

protocol KidsListViewModelProtocol {
    var kids: [Kid] { get set }
}

final class KidsListViewModel: KidsListViewModelProtocol {
    // MARK: - Properties
    var kids: [Kid] = []
    
    // MARK: - Initialization
    init() {
        setMocks()
    }
    // MARK: - Private Methods
    private func setMocks() {
        kids = [Kid(name: "Alisa",
                    dateOfBirth: .now - 4000, sex: .girl,
                    sleeps: [Sleep(startDate: .now, endDate: .now + 60, sleepType: .day)]),
                Kid(name: "Alex",
                    dateOfBirth: .now - 9000, sex: .boy,
                    sleeps: [Sleep(startDate: .now + 100, endDate: .now + 2600, sleepType: .night),
                             Sleep(startDate: .now + 3600, endDate: .now + 4260, sleepType: .day),
                             Sleep(startDate: .now + 3100, endDate: .now + 3260, sleepType: .day),
                             Sleep(startDate: .now, endDate: .now + 60, sleepType: .night)]
                   )
        ]
    }
}
