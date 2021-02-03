//
//  DetailPresenter.swift
//  MVPTest
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func setPlant(plant: Plant)
    func error(error: Error)
}

protocol DetailViewPresenterProtocol: class {
    var plant: Plant { get set }
    
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, plant: Plant, database: DatabaseServiceProtocol)
    
    func setPlant()
    func AddToFavouritesTapped()
    func setPlantIsFavourite()
}

class DetailPresenter: DetailViewPresenterProtocol {
    private weak var view: DetailViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol!
    private let databaseService: DatabaseServiceProtocol!
    var plant: Plant
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, plant: Plant, database: DatabaseServiceProtocol) {
        self.view = view
        self.networkService = networkService
        self.plant = plant
        self.router = router
        self.databaseService = database
    }
    
    func AddToFavouritesTapped() {
        do {
            let array = try databaseService.fetchPlants()
            if let dbPlant = array.first(where: { $0.id == plant.id }) {
                do {
                    plant.isFavourite = false
                    try databaseService.delete(plant: dbPlant)
                } catch (let error) {
                    view?.error(error: error)
                }
            } else {
                do {
                    plant.isFavourite = true
                    try databaseService.insertPlant(plant)
                } catch (let error) {
                    view?.error(error: error)
                }
            }
        } catch (let error) {
            view?.error(error: error)
        }
        
        
    }
    
    func setPlantIsFavourite() {
        do {
            let array = try databaseService.fetchPlants()
            guard let plantFromDB = array.first(where: { $0.id == plant.id }) else { return }
            plant.isFavourite = plantFromDB.isFavourite
        } catch (let error) {
            view?.error(error: error)
        }
    }
    
    func setPlant() {
        view?.setPlant(plant: plant)
    }
}
