//
//  UIViewController+Ex.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 20/05/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedOnScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap() {
        view.endEditing(true)
    }
}
