//
//  SleepsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 27/04/2024.
//

import Foundation

protocol SleepsListViewModelProtocol {
    var sleeps: [Sleep] { get set }
    var kidName: String { get set }
}

final class SleepsListViewModel: SleepsListViewModelProtocol {
    // MARK: - Properties
    var sleeps: [Sleep]
    var kidName: String
    
    // MARK: - Initialization
    init(sleeps: [Sleep], kidName: String) {
        self.sleeps = sleeps
        self.kidName = kidName
    }
    
    // MARK: - Private Methods
    private func setMocks() {

    }
}
