//
//  FavouritesViewController.swift
//  PlantDiscover
//
//  Created by Дмитрий on 29/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var presenter: FavouritesViewPresenterProtocol!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var errorAlert: UIAlertController?
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        title = "Favourites"
        setUpTableView()
        presenter.getPlantsFromDB()
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PlantTableViewCell.self, forCellReuseIdentifier: "plantsCell")
        tableView.separatorStyle = .none
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        tableView.backgroundColor = .systemBackground
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

extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.plantsFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "plantsCell", for: indexPath) as? PlantTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator
        let plant = presenter.plantsFromDB[indexPath.row]
        if let imageURL = plant.imageUrl, let avatarURL = URL(string: imageURL) {
            cell.plantImageView.kf.setImage(with: avatarURL, options: [.cacheOriginalImage])
        }
        cell.titleLabel.text = plant.commonName
        cell.subtitleLabel.text = plant.scientificName
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            tableView.beginUpdates()
            let removingPlant = presenter.plantsFromDB.remove(at: indexPath.row)
            presenter.removePlantFromDB(plant: removingPlant)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let plantClass = presenter.plantsFromDB[indexPath.row]
        let plant = Plant(id: Int(plantClass.id),
                          commonName: plantClass.commonName ?? "",
                          scientificName: plantClass.scientificName ?? "",
                          year: Int(plantClass.year),
                          bibliography: plantClass.bibliography ?? "",
                          author: plantClass.author ?? "",
                          status: plantClass.status ?? "",
                          rank: plantClass.rank ?? "",
                          familyCommonName: plantClass.familyCommonName ?? "",
                          imageUrl: plantClass.imageUrl ?? "")
        presenter.tapOnPlant(plant: plant)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}


extension FavouritesViewController: FavouritesViewProtocol {
    func success() {
        tableView.reloadData()
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = false
    }
    
    func error(error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension FavouritesViewController: PlantsDetailDelegate {
    func favouritesButtonDidClicked() {
        presenter.getPlantsFromDB()
    }
}
