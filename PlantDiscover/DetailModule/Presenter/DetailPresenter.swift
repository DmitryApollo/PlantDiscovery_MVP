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
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, plant: Plant, database: DatabaseServiceProtocol)
    
    func setPlant()
    func AddToFavouritesTapped()
    func setPlantIsFavourite()
    
    var plant: Plant { get set }
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
        guard let array = try? databaseService.fetchPlants() else { return }
        if let dbPlant = array.first(where: { $0.id == plant.id }) {
            do {
                plant.isFavourite = false
                try databaseService.delete(plant: dbPlant)
            } catch (let error) {
                print(error)
            }
        } else {
            do {
                plant.isFavourite = true
                try databaseService.insertPlant(plant)
            } catch (let error) {
                print(error)
            }
        }
    }
    
    func setPlantIsFavourite() {
        guard let array = try? databaseService.fetchPlants(),
            let plantFromDB = array.first(where: { $0.id == plant.id }) else { return }
        plant.isFavourite = plantFromDB.isFavourite
    }
    
    func setPlant() {
        self.view?.setPlant(plant: plant)
    }
}
