//
//  Sleep.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

struct Sleep {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let sleepType: SleepType
    var isNewSleep: Bool = true
    
    enum SleepType {
        case day, night, unowned
    }
}
