//
//  KidsListViewModel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import Foundation

protocol KidsListViewModelProtocol {
    var kids: [Kid] { get set }
    var reloadTable: (() -> Void)? { get set }
    var kidsCount: Int { get }
    var defaultKid: Kid { get }
    
    func getKids()
    func getKid(for row: Int) -> Kid
    func getKidAdge(for row: Int) -> String
    func getStartDate(for kid: Kid) -> Date
}

final class KidsListViewModel: KidsListViewModelProtocol {
    // MARK: - Properties
    var kids: [Kid] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    var kidsCount: Int {
        kids.count
    }
    
    var defaultKid: Kid {
        Kid(id: UUID(),
            name: "",
            birthDate: .now,
            sleeps: [])
    }
    
    var reloadTable: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        getKids()
    }
    // MARK: - Methods
    func getKids() {
        kids = KidPersistent.fetchAll()
    }
    
    func getKid(for row: Int) -> Kid {
        kids[row]
    }
    
    func getKidAdge(for row: Int) -> String {
        let kid = getKid(for: row)
        return DateHelper.shared.getKidAge(birthDate: kid.birthDate)
    }
    
    func getStartDate(for kid: Kid) -> Date {
        if let firstSleep = kid.sleeps.min(by: { $0.startDate < $1.startDate }) {
            return firstSleep.startDate
        } else {
            return .now
        }
    }
}
