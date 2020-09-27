//
//  RowCell.swift
//  IosExerciseA
//
//  Created by Nimmi P on 26/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit
import SnapKit

class RowCell: UITableViewCell {

    static let identifier: String = "row_cell"
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var rowImage: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    func configure(){
        titleLabel = UILabel(frame: .zero)
        descriptionLabel = UILabel(frame: .zero)
        rowImage = UIImageView()
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rowImage)
        self.contentView.addSubview(descriptionLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(14)
        }
        rowImage.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        descriptionLabel.snp.makeConstraints{
            $0.left.equalTo(titleLabel).offset(20)
            $0.right.equalTo(titleLabel).offset(-20)
            $0.top.equalTo(rowImage.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
