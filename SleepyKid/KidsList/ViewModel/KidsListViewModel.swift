//
//  KidsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

protocol KidsListViewModelProtocol {
    var kids: [Kid] { get set }
    var reloadTable: (() -> Void)? { get set }
    
    func getKids()
}

final class KidsListViewModel: KidsListViewModelProtocol {
    // MARK: - Properties
    var kids: [Kid] = []
    var reloadTable: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        getKids()
    }
    // MARK: - Private Methods
    func getKids() {
        kids = KidPersistent.fetchAll()
        print(kids)
    }
    
    // MARK: - Methods
    private func setMocks() {
        kids = [Kid(name: "Alisa",
                    dateOfBirth: .now - 4000,
                    sleeps: [Sleep(startDate: .now, endDate: .now + 60, sleepType: .day)]),
                Kid(name: "Alex",
                    dateOfBirth: .now - 9000,
                    sleeps: [Sleep(startDate: .now + 100, endDate: .now + 2600, sleepType: .night),
                             Sleep(startDate: .now + 3600, endDate: .now + 4260, sleepType: .day),
                             Sleep(startDate: .now + 3100, endDate: .now + 3260, sleepType: .day),
                             Sleep(startDate: .now, endDate: .now + 60, sleepType: .night)]
                   )
        ]
    }
}
