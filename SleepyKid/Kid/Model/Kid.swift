//
//  Kid.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

struct Kid {
    let id: UUID
    let name: String
    let birthDate: Date
    let parent: User = User()
    var sleeps: [Sleep] = []
}
