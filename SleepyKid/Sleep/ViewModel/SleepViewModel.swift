//
//  SleepViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import Foundation


protocol SleepViewModelProtocol {
    var sleep: Sleep? { get set }
    var kid: Kid? { get set }
    var isNewSleep: Bool { get }
    
    func save(with startDate: Date, and endDate: Date)
    func delete()
    func getTimeIntervalText(for startDate: Date, and endDate: Date) -> String
    func getSleepInterval(from startDate: Date, to endDate: Date) -> String
    func getSleepType(from startDate: Date, to endDate: Date) -> SleepType
    func getFormatted(date: Date) -> String
    func getTrimmed(date: Date) -> Date
}

final class SleepViewModel: SleepViewModelProtocol {
    // MARK: - Properties
    var sleep: Sleep?
    var kid: Kid?
    var isNewSleep: Bool {
        sleep == nil
    }
    
    private var sleepID: UUID {
        ((sleep == nil) ? UUID() : sleep?.id) ?? UUID()
    }
    
    // MARK: Initialization
    init(sleep: Sleep?, kid: Kid?) {
        self.sleep = sleep
        self.kid = kid
    }
    
    // MARK: - Methods
    func save(with startDate: Date, and endDate: Date) {
        let trimmedStartDate = getTrimmed(date: startDate)
        let trimmedEndDate = getTrimmed(date: endDate)
        
        let sleepToSave = Sleep(id: sleepID,
                                startDate: trimmedStartDate,
                                endDate: trimmedEndDate)
        
        SleepPersistent.save(sleepToSave, 
                             for: kid ?? Kid(id: UUID(),
                                             name: "",
                                             birthDate: .now,
                                             sleeps: []))
    }
    
    func delete() {
        guard let sleep else { return }
        SleepPersistent.deleteSleep(sleep)
    }
    
    func getTimeIntervalText(for startDate: Date, and endDate: Date) -> String {
        let trimmedStartDate = getTrimmed(date: startDate)
        let trimmedEndDate = getTrimmed(date: endDate)
        let formattedStartTime = getFormatted(date: trimmedStartDate)
        let formattedEndTime = getFormatted(date: trimmedEndDate)
        
        return "\(formattedStartTime) - \(formattedEndTime)"
    }
    
    func getSleepInterval(from startDate: Date, to endDate: Date) -> String {
        let trimmedStartDate = getTrimmed(date: startDate)
        let trimmedEndDate = getTrimmed(date: endDate)
        
        return DateHelper.shared.defineSleepInterval(from: trimmedStartDate,
                                                     to: trimmedEndDate)
    }
    
    func getSleepType(from startDate: Date, to endDate: Date) -> SleepType {
        DateHelper.shared.defineSleepType(from: startDate, to: endDate)
    }
    
    func getFormatted(date: Date) -> String {
        DateHelper.shared.format(date: date, with: "h:mm a")
    }
    
    func getTrimmed(date: Date) -> Date {
        DateHelper.shared.trimSeconds(from: date)
    }
}
