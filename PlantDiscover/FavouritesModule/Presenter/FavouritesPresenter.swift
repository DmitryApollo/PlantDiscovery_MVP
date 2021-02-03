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
    func error(error: Error)
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
        do {
            let array = try databaseService.fetchPlants()
            plantsFromDB = array
            view?.success()
        } catch (let error) {
            view?.error(error: error)
        }
        
    }
    
    func removePlantFromDB(plant: PlantClass) {
        do {
            try databaseService.delete(plant: plant)
        } catch (let error) {
            view?.error(error: error)
        }
    }
    
    func tapOnPlant(plant: Plant) {
        router?.showDetail(plant: plant)
    }
}
