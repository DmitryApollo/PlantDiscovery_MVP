//
//  RepoPresenter.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

enum CurrentRequest {
    case feeds
    case search
}

protocol PlantsViewProtocol: class {
    func success()
    func failure(error: Error)
    var page: Int { get set }
    var pageOfSearch: Int { get set }
}

protocol PlantsViewPresenterProtocol : class {
    var plants: [Plant] { get set }
    var plantsFromSearch: [Plant] { get set }
    var totalCount: Int? { get set }
    var totalCountFromSearch: Int? { get set }
    var currentRequest: CurrentRequest { get set }
    
    init(view: PlantsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    
    func searchPlant(plantName: String, page: Int)
    func getPlants(page: Int)
    func tapOnRepo(plant: Plant)
}

class PlantsPresenter: PlantsViewPresenterProtocol {
    private weak var view: PlantsViewProtocol?
    private var router: RouterProtocol?
    private let networkService: NetworkServiceProtocol!
    var plants: [Plant] = []
    var plantsFromSearch: [Plant] = []
    var totalCountFromSearch: Int?
    var totalCount: Int?
    var currentRequest: CurrentRequest
    
    required init(view: PlantsViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.currentRequest = .feeds
    }
    
    func tapOnRepo(plant: Plant) {
        router?.showDetail(plant: plant)
    }
    
    func getPlants(page: Int) {
        networkService.getPlants(page: page) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    if let list = list {
                        self.currentRequest = .feeds
                        self.totalCount = list.total
                        if self.view?.page == 1 {
                            self.plants = list.data
                        } else {
                            self.plants.append(contentsOf: list.data)
                        }
                    }
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func searchPlant(plantName: String, page: Int) {
        networkService.searchPlant(plantName: plantName, page: page) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    if let list = list {
                        self.currentRequest = .search
                        self.totalCountFromSearch = list.total
                        if self.view?.pageOfSearch == 1 {
                            self.plantsFromSearch = list.data
                        } else {
                            self.plantsFromSearch.append(contentsOf: list.data)
                        }
                    }
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
