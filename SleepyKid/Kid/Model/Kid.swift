//
//  Kid.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

struct Kid {
    let name: String
    let dateOfBirth: Date
    let parent: User = User()
    var sleeps: [Sleep] = []
    var isNewKid: Bool = true
}
