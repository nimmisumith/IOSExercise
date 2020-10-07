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
    
    /*  This class designs individual views in a single tableview cell */
    
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var rowImage: UIImageView!
    
    // Setting data in individual views from viewmodel, when cell viewmodel data is set.
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
    private func configure(){
        //setup contentview's constraints
        self.contentView.snp.makeConstraints{
            $0.top.left.bottom.right.equalToSuperview()
        }
        //create stackview with vertical alignment, add it to contentview
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = Constants.stack_spacing
        self.contentView.addSubview(stack)
        //stackview's constraints
        stack.snp.makeConstraints{ make in
            make.top.left.equalTo(Constants.stack_padding)
            make.bottom.right.equalTo(-Constants.stack_padding)
        }
        //title label
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.purple
        // description label
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = Constants.infinite_lines
        descriptionLabel.textColor = UIColor.darkGray
        //imageview
        rowImage = UIImageView()
        titleLabel.font = UIFont.boldSystemFont(ofSize: getSize(input: CGFloat(Constants.title_fontsize)))
        descriptionLabel.font = UIFont.systemFont(ofSize: getSize(input: CGFloat(Constants.normal_fontsize)))
        
        //adding views to the stackview
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(rowImage)
        stack.addArrangedSubview(descriptionLabel)
        
    }
    
    //resizing image to a fixed size area
    private func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: Constants.image_width,height: Constants.image_height),scaleMode: .aspectFit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

