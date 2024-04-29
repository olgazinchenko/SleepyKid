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
    let sex: Sex
    let photoUrl: URL?
    var sleeps: [Sleep]
    let parent: User = User()
    
    enum Sex {
        case girl, boy
    }
}
