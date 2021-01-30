//
//  FavouritesPresenter.swift
//  PlantDiscover
//
//  Created by Дмитрий on 29/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol FavouritesViewProtocol: class {
    func success()
}

protocol FavouritesViewPresenterProtocol: class {
    var plantsFromDB: [PlantClass] { get set }
    
    init(view: FavouritesViewProtocol, database: DatabaseServiceProtocol, router: RouterProtocol)
    
    func getPlantsFromDB()
    func removePlantFromDB(plant: PlantClass)
    func tapOnPlant(plant: Plant)
}

class FavouritesPresenter: FavouritesViewPresenterProtocol {
    var plantsFromDB: [PlantClass] = []
    var router: RouterProtocol?
    weak var view: FavouritesViewProtocol?
    let databaseService: DatabaseServiceProtocol!
    
    required init(view: FavouritesViewProtocol, database: DatabaseServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.databaseService = database
        self.router = router
    }
    
    func getPlantsFromDB() {
        guard let array = try? databaseService.fetchPlants() else { return }
        plantsFromDB = array
        view?.success()
    }
    
    func removePlantFromDB(plant: PlantClass) {
        try? databaseService.delete(plant: plant)
    }
    
    func tapOnPlant(plant: Plant) {
        router?.showDetail(plant: plant)
    }
}
