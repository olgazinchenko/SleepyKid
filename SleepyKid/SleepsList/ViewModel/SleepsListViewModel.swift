//
//  SleepsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 27/04/2024.
//

import Foundation

protocol SleepsListViewModelProtocol {
    var sleeps: [Sleep] { get set }
    var kid: Kid { get set }
    var kidName: String { get }
    var reloadTable: (() -> Void)? { get set }
    var section: [TableViewSection] { get }
    var sectionCount: Int { get }
    
    func getSleeps(for kid: Kid, on date: Date)
    func getSleep(for kid: Kid, and indexPath: IndexPath) -> Sleep
    func getTitle(for section: Int) -> String
    func getNumberOfRows(for sectionIndex: Int) -> Int
    func isAwakeDurationRow(at indexPath: IndexPath) -> Bool
    func getAwakeDuration(for indexPath: IndexPath) -> String
}

final class SleepsListViewModel: SleepsListViewModelProtocol {
    // MARK: - Properties
    var kid: Kid
    var sleeps: [Sleep] = []
    
    var kidName: String {
        kid.name
    }
    
    var reloadTable: (() -> Void)?
    
    var sectionCount: Int {
        section.count
    }
    
    // Keep track of the selected date so we can title the section
    private var selectedDate: Date = .now
    
    // Flat list of items (Sleep + SleepAwakeDurationItem) for that day
    private(set) var items: [TableViewItemProtocol] = [] {
        didSet { reloadTable?() }
    }
    
    // Always a single section
    var section: [TableViewSection] {
        let title = DateHelper.shared.format(date: selectedDate, with: "d MMM yyyy")
        return [ TableViewSection(title: title, items: items) ]
    }
    
    // MARK: - Initialization
       init(kid: Kid) {
           self.kid = kid
           getSleeps(for: kid, on: .now)
       }
       
    // MARK: - Methods
    func getSleeps(for kid: Kid, on date: Date) {
        selectedDate = date
        
        let all = SleepPersistent.fetchSleeps(for: kid)
        let startOfDay = DateHelper.shared.getStartOfDay(for: date)
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        else { sleeps = []; items = []; return }
        
        sleeps = all
            .filter { $0.startDate >= startOfDay && $0.startDate < endOfDay }
            .sorted { $0.startDate < $1.startDate }
           
        var newItems: [TableViewItemProtocol] = []
        for (idx, sleep) in sleeps.enumerated() {
            newItems.append(sleep)
            if idx < sleeps.count - 1 {
                let next = sleeps[idx + 1]
                let awake = DateHelper.shared.defineTimeInterval(from: sleep.endDate,
                                                                 to: next.startDate)
                newItems.append(SleepAwakeDurationItem(duration: awake))
            }
        }
        items = newItems
    }
       
    func getSleep(for kid: Kid, and indexPath: IndexPath) -> Sleep {
        let item = section[indexPath.section].items[indexPath.row]
        guard let sleep = item as? Sleep else {
            fatalError("Expected a Sleep at row \(indexPath.row)")
        }
        return sleep
    }
       
    func getTitle(for sectionIndex: Int) -> String {
        section[sectionIndex].title ?? ""
    }
       
    func getNumberOfRows(for sectionIndex: Int) -> Int {
        section[sectionIndex].items.count
    }
       
    func isAwakeDurationRow(at indexPath: IndexPath) -> Bool {
        section[indexPath.section].items[indexPath.row] is SleepAwakeDurationItem
    }
       
    func getAwakeDuration(for indexPath: IndexPath) -> String {
        let item = section[indexPath.section].items[indexPath.row]
        return (item as? SleepAwakeDurationItem)?.duration ?? ""
    }
}
