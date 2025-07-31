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

    func showSleepsListViewController(for kid: Kid, startDate: Date) {
        let viewModel = SleepsListViewModel(kid: kid)
        let vc = SleepsListViewController(viewModel: viewModel, startDate: startDate)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showSleepViewController(for sleep: Sleep?,
                                 sleepNumber: Int?,
                                 kid: Kid?,
                                 selectedDate: Date? = nil,
                                 onSave: ((Date) -> Void)? = nil,
                                 onDelete: (() -> Void)? = nil) {
        let viewModel = SleepViewModel(sleep: sleep, sleepNumber: sleepNumber, kid: kid)
        let vc = SleepViewController(viewModel: viewModel)
        vc.selectedDate = selectedDate
        vc.onSave = onSave
        vc.onDelete = onDelete
        navigationController.pushViewController(vc, animated: true)
    }
} 
