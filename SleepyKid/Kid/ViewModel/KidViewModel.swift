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
}

final class KidViewModel: KidViewModelProtocol {
    var kid: Kid?
    var isNewKid: Bool = true
    
    init(kid: Kid?) {
        self.kid = kid
    }
}
