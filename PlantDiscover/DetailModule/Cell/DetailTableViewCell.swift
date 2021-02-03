//
//  DetailTableViewCell.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {
    
    let stackView = UIStackView()
    let mainInformationLabel = UILabel()
    let yearLabel = UILabel()
    let bibliographyLabel = UILabel()
    let authorLabel = UILabel()
    let statusLabel = UILabel()
    let rankLabel = UILabel()
    let familyCommonNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpStackView()
    }
    
    func setUpLabels(plant: Plant) {
        familyCommonNameLabel.text = "Family: \(plant.familyCommonName ?? "")"
        rankLabel.text = "Rank: \(plant.rank ?? "")"
        statusLabel.text = "Status: \(plant.status ?? "")"
        authorLabel.text = "Author: \(plant.author ?? "")"
        yearLabel.text = "Year: \(plant.year ?? 0)"
        bibliographyLabel.text = "Bibliography: \(plant.bibliography ?? "")"
    }
    
    private func setUpStackView() {
        addSubview(stackView)
        
        mainInformationLabel.font = UIFont.boldSystemFont(ofSize: labelsFontSize + 6)
        mainInformationLabel.text = "Main Information"
        
        familyCommonNameLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        familyCommonNameLabel.text = "Family name: "
        
        rankLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        rankLabel.text = "Rank: "
        
        statusLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        statusLabel.text = "Status: "
        
        authorLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        authorLabel.text = "Author: "
        
        yearLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        yearLabel.text = "Year: "
        
        bibliographyLabel.font = UIFont.systemFont(ofSize: labelsFontSize - 4)
        bibliographyLabel.text = "Bibliography: "
        
        stackView.addArrangedSubview(mainInformationLabel)
        stackView.addArrangedSubview(familyCommonNameLabel)
        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(bibliographyLabel)
        
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.backgroundColor = .white
        
        stackView.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview().offset(8)
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-8)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainInformationLabel.text = ""
        familyCommonNameLabel.text = ""
        rankLabel.text = ""
        statusLabel.text = ""
        authorLabel.text = ""
        yearLabel.text = ""
        bibliographyLabel.text = ""
    }
}
