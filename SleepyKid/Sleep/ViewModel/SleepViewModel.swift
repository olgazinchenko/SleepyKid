//
//  SleepViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import Foundation


protocol SleepViewModelProtocol {
    var sleep: Sleep? { get set }
}

final class SleepViewModel: SleepViewModelProtocol {
    // MARK: - Properties
    var sleep: Sleep?
    
    // MARK: Initialization
    init(sleep: Sleep?) {
        self.sleep = sleep
    }
}
