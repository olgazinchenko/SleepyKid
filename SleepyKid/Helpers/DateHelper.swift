//
//  DateTimeHelper.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 10/05/2024.
//

import Foundation

final class DateHelper {
    // MARK: Singleton Setup
    static let shared = DateHelper()
    
    // MARK: Methods
    func defineTimeInterval(from startDate: Date, to endDate: Date) -> String {
        let sleepInterval = Int(endDate.timeIntervalSince(startDate))
        let hours = sleepInterval / 3600
        let minutes = (sleepInterval % 3600) / 60
        return (hours == 0) ? ("\(minutes) min") : ("\(hours) h \(minutes) min")
    }
    
    func format(date: Date, with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func trimSeconds(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                 from: date)
        return calendar.date(from: components) ?? date
    }
    
    func getStartOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return startOfDay
    }
    
    func getDates(from startDate: Date) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let start = calendar.startOfDay(for: startDate)
        
        guard start <= today else { return [] }
        
        var dates: [Date] = []
        var currentDate = start
        
        while currentDate <= today {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day,
                                               value: 1,
                                               to: currentDate) else { break }
            currentDate = nextDate
        }
        return dates
    }
    
    func defineSleepType(from startTime: Date, to endTime: Date) -> SleepType {
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
        
        // Check if a start date is after or equal an end date
        if startTime >= endTime {
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
