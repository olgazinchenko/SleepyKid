//
//  DateTimeHelper.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 10/05/2024.
//

import Foundation

final class DateHelper {
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
        
        // Get the calendar and components for comparison
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .day], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .day], from: endTime)
        
        // Extract the hour and day components
        guard let startHour = startComponents.hour,
              let endHour = endComponents.hour,
              let startDay = startComponents.day,
              let endDay = endComponents.day else {
            return .unowned
        }
        
        // Check if start date is after end date
        if startTime > endTime {
            return .unowned
        }
        
        // When the start of the sleep is on one date and the end of the sleep is on another date
        if startDay != endDay {
            return .night
        }
        
        // Check if the start time is after the night sleep start time
        if startHour >= nightSleepStartHour || startHour < nightSleepEndHour {
            return .night
        }
        
        // When the end of the sleep is on the same day, but after 20:00
        if endHour >= nightSleepStartHour {
            return .night
        }
        
        // Sleep happening on the same date in the interval from 5:00 till 20:00
        if startHour >= nightSleepEndHour && endHour < nightSleepStartHour {
            return .day
        }
        
        // Default case, not covered by any other condition
        return .unowned
    }
}
