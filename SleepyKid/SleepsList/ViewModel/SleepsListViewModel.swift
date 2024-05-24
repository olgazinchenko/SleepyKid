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
}

final class SleepsListViewModel: SleepsListViewModelProtocol {
    // MARK: - Properties
    var sleeps: [Sleep]
    var kid: Kid
    
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
    init(sleeps: [Sleep], kid: Kid) {
        self.sleeps = sleeps
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
            
            return TableViewSection(title: stringDate, items: sortedSleeps)
        }
    }
    
    func getSleep(for kid: Kid, and indexPath: IndexPath) -> Sleep {
        section[indexPath.section].items[indexPath.row] as! Sleep
    }
    
    func getTitle(for sectionIndex: Int) -> String {
        section[sectionIndex].title ?? ""
    }
    
    func getNumberOfRows(for sectionIndex: Int) -> Int {
        section[sectionIndex].items.count
    }
}
