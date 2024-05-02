//
//  KidViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 02/05/2024.
//

import Foundation

protocol KidViewModelProtocol {
    var kid: Kid { get set }
}

final class KidViewModel: KidViewModelProtocol {
    var kid: Kid
    
    init(kid: Kid) {
        self.kid = kid
    }
}
