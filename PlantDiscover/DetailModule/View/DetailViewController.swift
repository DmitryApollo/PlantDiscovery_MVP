//
//  DetailViewController.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import Kingfisher

protocol PlantsDetailDelegate: class {
    func favouritesButtonDidClicked()
}

class DetailViewController: UIViewController {
    private let imageView = UIImageView()
    private let favouritesView = UIView()
    private let favouritesActionButton = UIButton(type: .system)
    
    private let clearView = UIView()
    private let commonNameLabel = UILabel()
    private let scientificNameLabel = UILabel()
    
    private let tableView = UITableView()
    
    var presenter: DetailViewPresenterProtocol!
    weak var delegate: PlantsDetailDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        presenter.setPlantIsFavourite()
        setUpUI()
        setUpTableView()
        presenter.setPlant()
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)

        tableView.dataSource = self
        
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "detailCell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        tableView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.top.equalTo(favouritesView.snp.bottom)
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
    }
    
    private func setUpUI() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.height.equalTo(248)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
        imageView.addSubview(clearView)
        clearView.snp.makeConstraints { (maker) in
            maker.height.equalTo(84)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-20)
        }
    
        commonNameLabel.textColor = .white
        commonNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        clearView.addSubview(commonNameLabel)
        commonNameLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(40)
            maker.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.leading.leading.equalToSuperview().offset(20)
        }
        
        scientificNameLabel.textColor = .white
        scientificNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        clearView.addSubview(scientificNameLabel)
        scientificNameLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
            maker.trailing.equalToSuperview()
            maker.top.equalTo(commonNameLabel.snp.bottom)
        }
        
        view.addSubview(favouritesView)
        favouritesView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.top.equalTo(imageView.snp.bottom)
            maker.height.equalTo(48)
        }
    
        favouritesView.backgroundColor = .white
        favouritesView.addSubview(favouritesActionButton)
        
        favouritesActionButton.addTarget(self, action: #selector(AddOrRemoveFromFavouritesAction), for: .touchUpInside)
        favouritesActionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        setTitleToFavouritesButton()
        favouritesActionButton.layer.cornerRadius = 10
        favouritesActionButton.backgroundColor = .systemGray5
        favouritesActionButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(view.frame.width * 0.65)
            maker.height.equalTo(26)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setTitleToFavouritesButton() {
        if presenter.plant.isFavourite {
            favouritesActionButton.setTitle("REMOVE FROM FAVOURITES", for: .normal)
        } else {
            favouritesActionButton.setTitle("ADD TO FAVOURITES", for: .normal)
        }
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
    }
    
    @objc func AddOrRemoveFromFavouritesAction() {
        presenter.AddToFavouritesTapped()
        setTitleToFavouritesButton()
        delegate?.favouritesButtonDidClicked()
    }
}

extension DetailViewController: DetailViewProtocol {
    func setPlant(plant: Plant) {
        commonNameLabel.text = plant.commonName
        scientificNameLabel.text = plant.scientificName
        
        if let urlString = plant.imageUrl, let avatarURL = URL(string: urlString) {
            imageView.contentMode = .scaleAspectFill
            imageView.loadImage(fromURL: avatarURL)
        }
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as? DetailTableViewCell
        cell?.setUpLabels(plant: presenter.plant)
        return cell ?? UITableViewCell()
    }
}
