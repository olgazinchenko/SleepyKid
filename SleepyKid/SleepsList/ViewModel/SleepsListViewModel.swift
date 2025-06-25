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
    
    func getSleeps(for kid: Kid)
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
    
    private(set) var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    // MARK: - Initialization
    init(kid: Kid) {
        self.kid = kid
        getSleeps(for: kid)
    }
    
    // MARK: - Methods
    func getSleeps(for kid: Kid) {
        sleeps = SleepPersistent.fetchSleeps(for: kid)
        
        let groupedObjects = Dictionary(grouping: sleeps) { sleep in
            DateHelper().getStartOfDay(for: sleep.startDate)
        }
        
        let sortedKeys = groupedObjects.keys.sorted(by: >)
        
        section = sortedKeys.map { key in
            let stringDate = DateHelper.shared.format(date: key, with: "d MMM yyyy")
            let sortedSleeps = groupedObjects[key]?.sorted(by: { $0.startDate < $1.startDate }) ?? []
            
            var items: [TableViewItemProtocol] = []
            
            for (index, sleep) in sortedSleeps.enumerated() {
                items.append(sleep)
                
                if index < sortedSleeps.count - 1 {
                    let nextSleep = sortedSleeps[index + 1]
                    let awakeDuration = DateHelper.shared.defineTimeInterval(from:sleep.endDate,
                                                                             to: nextSleep.startDate)
                    let awakeItem = SleepAwakeDurationItem(duration: awakeDuration)
                    items.append(awakeItem)
                }
            }
            
            return TableViewSection(title: stringDate, items: items)
        }
    }
    
    func getSleep(for kid: Kid, and indexPath: IndexPath) -> Sleep {
        let item = section[indexPath.section].items[indexPath.row]
        if let sleep = item as? Sleep {
            return sleep
        } else {
            fatalError("Attempting to get Sleep from awake duration row")
        }
    }
    
    func getTitle(for sectionIndex: Int) -> String {
        section[sectionIndex].title ?? ""
    }
    
    func getNumberOfRows(for sectionIndex: Int) -> Int {
        section[sectionIndex].items.count
    }
    
    func isAwakeDurationRow(at indexPath: IndexPath) -> Bool {
        let item = section[indexPath.section].items[indexPath.row]
        return item is SleepAwakeDurationItem
    }
    
    func getAwakeDuration(for indexPath: IndexPath) -> String {
        let item = section[indexPath.section].items[indexPath.row]
        if let awakeItem = item as? SleepAwakeDurationItem {
            return awakeItem.duration
        }
        return ""
    }
}
