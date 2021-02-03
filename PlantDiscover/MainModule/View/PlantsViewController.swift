//
//  RepoViewController.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

class PlantsViewController: UIViewController {

    var presenter: PlantsViewPresenterProtocol!
    private let searchController = UISearchController(searchResultsController: nil)
    private var collectionView: UICollectionView?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    private var isLoading: Bool = false
    var page = 1
    var pageOfSearch = 1
    private var isRequestSuccessful: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        presenter.getPlants(page: page)
        setUpSearchController()
        setUpCollectionView()
        setUpActivityIndicator()
    }
    
    //MARK: set up UI
    private func setUpSearchController() {
        self.title = "Search"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
    }

    private func setUpCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = cellSize
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.register(PlantCollectionViewCell.self, forCellWithReuseIdentifier: "plantCell")
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView ?? UICollectionView())
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}

extension PlantsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch presenter.currentRequest {
        case .feeds:
            return presenter.plants.count
        case .search:
            return presenter.plantsFromSearch.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plantCell", for: indexPath) as? PlantCollectionViewCell
        
        var plant: Plant?
        switch presenter.currentRequest {
        case .feeds:
            plant = presenter.plants[indexPath.row]
        case .search:
            plant = presenter.plantsFromSearch[indexPath.row]
        }
        
        if let urlString = plant?.imageUrl, let avatarURL = URL(string: urlString) {
            cell?.imageView.kf.setImage(with: avatarURL)
        }
        cell?.titleLabel.text = plant?.commonName ?? "No name"
        cell?.subtitleLabel.text = plant?.scientificName
        return cell ?? UICollectionViewCell()
    }
}

extension PlantsViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .white
        
        let textLabel = UILabel()
        textLabel.text = "Plants"
        textLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        clearView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(18)
            maker.width.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.height.equalTo(44)
        }
        
        return clearView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch presenter.currentRequest {
        case .feeds:
            guard !isLoading, let totalCount = presenter.totalCount else { return }
            
            if totalCount > 20,
                indexPath.row == presenter.plants.count - 1,
                presenter.plants.count < totalCount {
                isLoading = true
                
                if isRequestSuccessful {
                    page += 1
                    isRequestSuccessful = false
                }
                
                presenter.getPlants(page: page)
            }
            
        case .search:
            guard !isLoading, let totalCount = presenter.totalCountFromSearch else { return }
            
            if totalCount > 20,
                indexPath.row == presenter.plantsFromSearch.count - 1,
                presenter.plantsFromSearch.count < totalCount {
                isLoading = true
                if isRequestSuccessful {
                    pageOfSearch += 1
                    isRequestSuccessful = false
                }
                if let text = searchController.searchBar.searchTextField.text {
                    presenter.searchPlant(plantName: text, page: pageOfSearch)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch presenter.currentRequest {
        case .feeds:
            let plant = presenter.plants[indexPath.row]
            presenter.tapOnRepo(plant: plant)
        case .search:
            let plant = presenter.plantsFromSearch[indexPath.row]
            presenter.tapOnRepo(plant: plant)
        }
    }
}

extension PlantsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.count == 0 {
            presenter.currentRequest = .feeds
            collectionView?.reloadData()
            collectionView?.isHidden = false
            searchBar.resignFirstResponder()
        }
        
        guard pageOfSearch != 1 else { return }
        pageOfSearch = 1
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.searchTextField.text, !searchText.isEmpty, searchText.count != 0 else {
            presenter.plants = []
            collectionView?.reloadData()
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            return
        }
        presenter.searchPlant(plantName: searchText, page: pageOfSearch)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        collectionView?.isHidden = true
    }
}

extension PlantsViewController: PlantsViewProtocol {
    
    func success() {
        collectionView?.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        collectionView?.isHidden = false
        isLoading = false
        isRequestSuccessful = true
    }
    
    func failure(error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        errorAlert?.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        guard let errorAlert = errorAlert else { return }
        present(errorAlert, animated: true)
        isLoading = false
        isRequestSuccessful = false
    }
}

