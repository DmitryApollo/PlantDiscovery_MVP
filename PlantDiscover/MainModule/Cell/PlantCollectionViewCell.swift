//
//  PlantCollectionViewCell.swift
//  PlantDiscover
//
//  Created by Дмитрий on 30/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class PlantCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        
        addSubview(imageView)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(8)
        }
        imageView.backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.layer.cornerRadius = 5
        titleLabel.textAlignment = .center
        titleLabel.layer.masksToBounds = true
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imageView.snp.bottom).offset(8)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(20)
        }
        titleLabel.backgroundColor = .white
        
        addSubview(subtitleLabel)
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
        
        subtitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(8)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
            maker.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
    }
}