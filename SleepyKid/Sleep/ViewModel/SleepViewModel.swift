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
    func getSleepIntervalText(from startDate: Date, to endDate: Date) -> String
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
    func getSleepIntervalText(from startDate: Date, to endDate: Date) -> String {
        let sleepInterval = Int(endDate.timeIntervalSince(startDate))
        let hours = sleepInterval / 3600
        let minutes = (sleepInterval % 3600) / 60
        return (hours == 0) ? ("\(minutes) min") : ("\(hours) h \(minutes) min")
    }
    
    func format(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "h:mm a"
        return dateFormater.string(from: date)
    }
    
    func defineSleepType(from startTime: Date, to endTime: Date) -> Sleep.SleepType {
        // Define the night sleep interval
        let nightSleepStartHour = 20
        let nightSleepEndHour = 5
        
        // Check if start date is after end date
        if startTime > endTime {
            return .unowned
        }
        
        // Get the calendar and components for comparison
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour], from: startTime)
        let endComponents = calendar.dateComponents([.hour], from: endTime)
        
        // Extract the hour component
        guard let startHour = startComponents.hour, let endHour = endComponents .hour else {
            return .unowned
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
