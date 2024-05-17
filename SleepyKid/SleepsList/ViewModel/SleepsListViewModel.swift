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
    var section: [TableViewSection] { get }
    
    func getSleeps(for kid: Kid)
    var reloadTable: (() -> Void)? { get set }
}

final class SleepsListViewModel: SleepsListViewModelProtocol {
    // MARK: - Properties
    var sleeps: [Sleep]
    var kid: Kid
    var reloadTable: (() -> Void)?
    
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
            Calendar.current.startOfDay(for: sleep.startDate)
        }
        
        let sortedKeys = groupedObjects.keys.sorted(by: >)
        
        section = sortedKeys.map { key in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            let stringDate = dateFormatter.string(from: key)
            let sortedSleeps = groupedObjects[key]?.sorted(by: { $0.startDate < $1.startDate }) ?? []

            return TableViewSection(title: stringDate, items: sortedSleeps)
        }
    }
}
