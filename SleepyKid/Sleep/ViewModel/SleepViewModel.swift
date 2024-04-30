//
//  SleepViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import Foundation


protocol SleepViewModelProtocol {
    var isNewSleep: Bool { get set }
    
    func secondsToHoursMinutes(seconds: Int) -> (hours: Int, minutes: Int)
    func format(date: Date) -> String
}

final class SleepViewModel: SleepViewModelProtocol {    
    // MARK: - Properties
    var sleep: Sleep?
    var isNewSleep: Bool = false
    
    // MARK: Initialization
    init(sleep: Sleep?) {
        self.sleep = sleep
    }
    
    // MARK: Methods
    func secondsToHoursMinutes(seconds: Int) -> (hours: Int, minutes: Int) {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return (hours, minutes)
    }
    
    func format(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "h:mm a"
        return dateFormater.string(from: date)
    }
}
