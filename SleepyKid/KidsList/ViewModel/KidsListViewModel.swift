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
    
    func getKids()
}

final class KidsListViewModel: KidsListViewModelProtocol {
    // MARK: - Properties
    var kids: [Kid] = [] {
        didSet {
            reloadTable?()
        }
    }
    var reloadTable: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        getKids()
    }
    // MARK: - Methods
    func getKids() {
        kids = KidPersistent.fetchAll()
        print(kids)
    }
}
