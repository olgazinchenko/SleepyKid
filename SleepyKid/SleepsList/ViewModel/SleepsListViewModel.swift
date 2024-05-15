//
//  SleepsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 27/04/2024.
//

import Foundation

protocol SleepsListViewModelProtocol {
    var sleeps: [Sleep] { get set }
    var kid: Kid { get set }
    
    func getSleeps(for kid: Kid)
    var reloadTable: (() -> Void)? { get set }
}

final class SleepsListViewModel: SleepsListViewModelProtocol {
    // MARK: - Properties
    var sleeps: [Sleep] {
        didSet {
            reloadTable?()
        }
    }
    var kid: Kid
    var reloadTable: (() -> Void)?
    
    // MARK: - Initialization
    init(sleeps: [Sleep], kid: Kid) {
        self.sleeps = sleeps
        self.kid = kid
        getSleeps(for: kid)
    }
    
    // MARK: - Methods
    func getSleeps(for kid: Kid) {
        sleeps = SleepPersistent.fetchSleeps(for: kid)
        print(sleeps)
        print(sleeps.count)
    }
}
