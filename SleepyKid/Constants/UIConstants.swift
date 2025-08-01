//
//  UIConstants.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 12/05/2024.
//

import UIKit

enum UIConstants {
    
    enum Layer {
        static let mainCornerRadius: CGFloat = 10
        static let mainBorderWidth: CGFloat = 1
        static let mainLabelColor: UIColor = .mainTextColor
        static let mainBackgroundColor: UIColor = .athensGray
    }
    
    enum FontSize {
        static let screenTitle: CGFloat = 18
        static let labelLarge: CGFloat = 17
        static let labelSmall: CGFloat = 15
    }
    
    enum Button {
        static let color: UIColor = .systemOrange
        // Action
        static let actionSize: CGFloat = 54
        static let actionTitleSize: CGFloat = 44
        static let actionCornerRadius: CGFloat = 27
        static let actionShadowRadius: CGFloat = 4
        //Arrow
        static let arrowSize: CGFloat = 32
        static let arrowTitleSize: CGFloat = 15
        static let arrowPointSize: CGFloat = 20
        static let arrowCornerRadius: CGFloat = 16
        static let arrowShadowRadius: CGFloat = 4
    }
}
