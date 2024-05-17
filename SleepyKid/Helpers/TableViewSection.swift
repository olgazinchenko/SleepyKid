//
//  TableViewSection.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 17/05/2024.
//

import Foundation

protocol TableViewItemProtocol {
    
}

struct TableViewSection {
    var title: String?
    var items: [TableViewItemProtocol]
}
