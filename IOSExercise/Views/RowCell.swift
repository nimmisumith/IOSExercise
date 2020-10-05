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
            $0.top.left.bottom.right.equalToSuperview()
        }
        
        let stack = UIStackView()
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = Constants.stack_spacing
        self.contentView.addSubview(stack)
        
        stack.snp.makeConstraints{ make in
            make.top.left.equalTo(Constants.stack_padding)
            make.bottom.right.equalTo(-Constants.stack_padding)
        }
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.purple
        descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = Constants.infinite_lines
        descriptionLabel.textColor = UIColor.darkGray
        rowImage = UIImageView()
        titleLabel.font = UIFont.boldSystemFont(ofSize: Utility.shared.getSize(input: CGFloat(Constants.title_fontsize), view: titleLabel))
        descriptionLabel.font = UIFont.systemFont(ofSize: Utility.shared.getSize(input: CGFloat(Constants.normal_fontsize), view: descriptionLabel))
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(rowImage)
        stack.addArrangedSubview(descriptionLabel)
        
    }
    
    //resizing image to a fixed size area
    func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: Constants.image_width,height: Constants.image_height),scaleMode: .aspectFit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
