//
//  ArrowButton.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 01/08/2025.
//

import Foundation

import UIKit

final class ArrowButton: UIButton {
    
    enum Direction {
        case left
        case right
        
        var systemImageName: String {
            switch self {
            case .left: return "arrow.backward"
            case .right: return "arrow.forward"
            }
        }
    }
    
    init(direction: Direction,
         size: CGFloat = UIConstants.Button.arrowSize,
         cornerRadius: CGFloat = UIConstants.Button.arrowCornerRadius,
         borderColor: UIColor = .systemOrange,
         tintColor: UIColor = .systemOrange) {
        
        super.init(frame: .zero)
        
        // Icon
        setImage(UIImage(systemName: direction.systemImageName), for: .normal)
        
        // Colors
        self.tintColor = tintColor
        backgroundColor = .clear
        
        // Border
        layer.borderWidth = 2
        layer.borderColor = borderColor.cgColor
        
        // Shape
        layer.cornerRadius = cornerRadius
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = UIConstants.Button.arrowShadowRadius
        
        // Size constraint
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size)
        ])
        
        // Font (if needed for title, though arrows use image only)
        titleLabel?.font = UIFont(
            name: "Poppins-Regular",
            size: UIConstants.Button.arrowTitleSize
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
