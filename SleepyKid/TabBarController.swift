//
//  TabBarController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Variables
    let kidsImage = UIImage(systemName: "face.smiling") ?? .add
    let sleepsImage = UIImage(systemName: "moon.zzz.fill") ?? .add
    let kidsTitle = "Kids".uppercased()
    let sleepsTitle = "Sleeps".uppercased()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        view.tintColor = .darkPurple
        
        setupViewController()
    }
    
    // MARK: - Private Methods
    private func setupViewController() {
        viewControllers = [
            setupNavigationController(rootViewController: KidsListViewController(), 
                                      title: kidsTitle,
                                      image: kidsImage),
            setupNavigationController(rootViewController: SleepsListViewController(), 
                                      title: sleepsTitle,
                                      image: sleepsImage)
        ]
    }
    
    private func setupNavigationController(rootViewController: UIViewController,
                                           title: String,
                                           image: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        
        return navigationController
    }
}
