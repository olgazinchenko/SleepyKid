//
//  SleepViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import Foundation


protocol SleepViewModelProtocol {
    var isNewSleep: Bool { get set }
    
    func defineSleepType(from startTime: Date, to endTime: Date) -> Sleep.SleepType
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
    
    func defineSleepType(from startTime: Date, to endTime: Date) -> Sleep.SleepType {
        // Define the night sleep interval
        let nightSleepStartHour = 21
        let nightSleepEndHour = 6
        
        // Get the calendar and components for comparison
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour], from: startTime)
        let endComponents = calendar.dateComponents([.hour], from: endTime)
        
        // Extract the hour component
        guard let startHour = startComponents.hour, let endHour = endComponents .hour else {
            return .day
        }
        
        // Check if the start time is after the night sleep start time
        if startHour >= nightSleepStartHour {
            return .night
        }
        
        // Check if the end time is before the night sleep end time
        if endHour < nightSleepEndHour {
            return .night
        }
        
        // Check if the sleep period spans across midnight
        if startHour < endHour && endHour < nightSleepStartHour {
            return .night
        }
        
        return .day
    }
}
