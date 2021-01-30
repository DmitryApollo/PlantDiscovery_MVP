//
//  Router.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showDetail(plant: Plant)
    func favouritesViewController()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navController = navigationController {
            guard let repoVC = assemblyBuilder?.createRepoModule(router: self) else { return }
            navController.viewControllers = [repoVC]
        }
    }
    
    func showDetail(plant: Plant) {
        if let navController = navigationController {
            guard let detailVC = assemblyBuilder?.createDetailModule(plant: plant, router: self) else { return }
            detailVC.modalPresentationCapturesStatusBarAppearance = true
            navController.pushViewController(detailVC, animated: true)
        }
    }
    
    func favouritesViewController() {
        if let navController = navigationController {
            guard let favouritesVC = assemblyBuilder?.createFavoritesModule(router: self) else { return }
            navController.viewControllers = [favouritesVC]
        }
    }
}
