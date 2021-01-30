//
//  ModelBuilder.swift
//  MVPTest
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createRepoModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(plant: Plant, router: RouterProtocol) -> UIViewController
    func createFavoritesModule(router: RouterProtocol) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    var favouritesVC: FavouritesViewController?
    
    func createRepoModule(router: RouterProtocol) -> UIViewController {
        let view = PlantsViewController()
        let networkService = NetworkService()
        let presenter = PlantsPresenter(view: view, networkService: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(plant: Plant, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let networkService = NetworkService()
        let database = DatabaseService()
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, plant: plant, database: database)
        view.presenter = presenter
        view.delegate = favouritesVC.self
        return view
    }
    
    func createFavoritesModule(router: RouterProtocol) -> UIViewController {
        let view = FavouritesViewController()
        let database = DatabaseService()
        let presenter = FavouritesPresenter(view: view, database: database, router: router)
        view.presenter = presenter
        favouritesVC = view
        return view
    }
}
