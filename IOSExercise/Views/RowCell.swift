//
//  RowCell.swift
//  IosExerciseA
//
//  Created by Nimmi P on 26/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class RowCell: UITableViewCell {
    
    static let identifier: String = "row_cell"
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var rowImage: UIImageView!
    
    // Setting data in cell views from viewmodel, when cell viewmodel data is set.
    var cellVM : CellViewModel?{
        didSet{
            
            titleLabel.text = cellVM?.rowtitle
            descriptionLabel.attributedText = NSAttributedString(string: cellVM?.descript ?? "")
            rowImage?.sd_setImage(with: URL(string: cellVM?.imageHref ?? ""), placeholderImage: nil, context: [.imageTransformer: getSDTransformer()])
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    //Table cell configuration, view alignment
    func configure(){
        self.contentView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        self.contentView.backgroundColor = UIColor.white
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = -1
        descriptionLabel.textColor = UIColor.black
        rowImage = UIImageView()
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rowImage)
        self.contentView.addSubview(descriptionLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Utility.shared.getSize(input: 26.0, view: titleLabel))
        descriptionLabel.font = UIFont.systemFont(ofSize: Utility.shared.getSize(input: 17.0, view: descriptionLabel))
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.right.equalTo(contentView.snp.right).offset(-20)
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.height.equalTo(50)
        }
        rowImage.snp.makeConstraints{
            
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        descriptionLabel.snp.makeConstraints{
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.top.greaterThanOrEqualTo(rowImage.snp.bottom).offset(10)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
    }
    
    //resizing image to a fixed size area
    func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: 300,height: 250),scaleMode: .aspectFit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
