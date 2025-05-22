//
//  Coordinator.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 17/05/2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = KidsListViewModel()
        let vc = KidsListViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.viewControllers = [vc]
    }

    func showKidViewController(for kid: Kid?) {
        let viewModel = KidViewModel(kid: kid)
        let vc = KidViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }

    func showSleepsListViewController(for kid: Kid) {
        let viewModel = SleepsListViewModel(kid: kid)
        let vc = SleepsListViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func showSleepViewController(for sleep: Sleep?, kid: Kid?) {
        let viewModel = SleepViewModel(sleep: sleep, kid: kid)
        let vc = SleepViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
} 
