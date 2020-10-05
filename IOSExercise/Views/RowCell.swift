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
    
    
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var rowImage: UIImageView!
    
    // Setting data in cell views from viewmodel, when cell viewmodel data is set.
    var cellVM : CellViewModel?{
        didSet{
            
            titleLabel.text = cellVM?.rowtitle
            descriptionLabel.attributedText = NSAttributedString(string: cellVM?.descript ?? Constants.emptyString)
            rowImage?.sd_setImage(with: URL(string: cellVM?.imageHref ?? Constants.emptyString), placeholderImage: nil, context: [.imageTransformer: getSDTransformer()])
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
        descriptionLabel.numberOfLines = Constants.infinite_lines
        descriptionLabel.textColor = UIColor.black
        rowImage = UIImageView()
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rowImage)
        self.contentView.addSubview(descriptionLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: Utility.shared.getSize(input: CGFloat(Constants.title_fontsize), view: titleLabel))
        descriptionLabel.font = UIFont.systemFont(ofSize: Utility.shared.getSize(input: CGFloat(Constants.normal_fontsize), view: descriptionLabel))
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(Constants.left_spacing)
            $0.right.equalTo(contentView.snp.right).offset(Constants.right_spacing)
            $0.top.equalTo(contentView.snp.top).offset(Constants.top_spacing)
          //  $0.height.equalTo(50)
        }
        rowImage.snp.makeConstraints{
            
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constants.top_spacing)
        }
        descriptionLabel.snp.makeConstraints{
            $0.leading.equalTo(contentView.snp.leading).offset(Constants.left_spacing)
            $0.trailing.equalTo(contentView.snp.trailing).offset(Constants.right_spacing)
            $0.top.greaterThanOrEqualTo(rowImage.snp.bottom).offset(Constants.top_spacing)
            $0.bottom.equalTo(contentView.snp.bottom).offset(Constants.bottom_spacong)
        }
        
    }
    
    //resizing image to a fixed size area
    func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: Constants.image_width,height: Constants.image_height),scaleMode: .aspectFit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
