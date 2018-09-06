//
//  HomeProductCell2.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class HomeProductCell2: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var btnViewMore2: UIButton!
    @IBOutlet weak var contentViewCell: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentViewCell.dropShadow()
        
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            btnViewMore2.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else{
            lblTitle.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
