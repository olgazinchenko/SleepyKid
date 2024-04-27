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
                    dateOfBirth: .now - 4000,
                    photoUrl: nil,
                    sleeps: [Sleep(startDate: .now, endDate: .now + 60)]),
                Kid(name: "Alex",
                    dateOfBirth: .now - 9000,
                    photoUrl: nil,
                    sleeps: [Sleep(startDate: .now + 100, endDate: .now + 260),
                             Sleep(startDate: .now + 100, endDate: .now + 260),
                             Sleep(startDate: .now + 100, endDate: .now + 260),
                             Sleep(startDate: .now, endDate: .now + 60)]
                   )
        ]
    }
}
