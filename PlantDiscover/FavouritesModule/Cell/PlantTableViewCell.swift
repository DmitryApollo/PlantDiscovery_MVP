//
//  RepoTableViewCell.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import UIKit
import SnapKit

class PlantTableViewCell: UITableViewCell {
    
    let mainView = UIView()
    let plantImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainView)
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        mainView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(8)
            maker.bottom.equalToSuperview().offset(-8)
            maker.leading.equalToSuperview().offset(8)
            maker.trailing.equalToSuperview().offset(-8)
        }
        
        mainView.addSubview(plantImageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(subtitleLabel)
        
        plantImageView.layer.cornerRadius = 10
        plantImageView.clipsToBounds = true
        
        plantImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(imageViewWidth)
            maker.height.equalTo(imageViewWidth)
            maker.leading.equalToSuperview().offset(16)
            maker.centerY.equalToSuperview()
        }
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: labelsFontSize)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(plantImageView.snp.trailing).offset(16)
            maker.trailing.equalToSuperview().offset(-32)
            maker.centerY.equalToSuperview().offset(-12)
        }
        
        subtitleLabel.font = UIFont.systemFont(ofSize: labelsFontSize)
        subtitleLabel.textColor = .gray
        
        subtitleLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(plantImageView.snp.trailing).offset(16)
            maker.trailing.equalToSuperview().offset(-32)
            maker.centerY.equalToSuperview().offset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        plantImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
    }
}
