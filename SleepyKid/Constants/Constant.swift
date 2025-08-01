//
//  Constant.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 12/05/2024.
//

import Foundation

enum Constant: String {
    case kidName = "Kid name"
    case dateOfBirth = "Date of birth"
    case startDate = "Start time and date"
    case endDate = "End time and date"
    case sleepDurationDefault = "0 h 0 min"
    case appIcon = "sleepyKidIcon"
    case timeBadge = "bed.double"
    case unownedImage = "unowned"
    case dayImage = "sun"
    case nightImage = "moon"
    case awakeImage = "circle.fill"
    case edit = "Edit"
    case name = "Name"
    case add = "Add"
    case cancel = "Cancel"
    case delete = "Delete"
    case editIcon = "square.and.pencil"
    case deleteIcon = "trash"
    case sleepsEmptyState = "No sleeps recorded for this day. \nTap + to add one."
    case kidsEmptyState = "Let’s start by adding your kid!\nTap + to begin."
    case deleteSleepAlertTitle = "Delete Sleep?"
    case deleteSleepAlertText = "Are you sure you want to remove the sleep?"
    case deleteKidAlertTitle = "Delete Kid?"
    case deleteKidAlertText = "This will remove the kid and all associated sleeps. Are you sure?"
}
