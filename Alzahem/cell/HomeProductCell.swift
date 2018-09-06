//
//  HomeProductCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class HomeProductCell: UITableViewCell {

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
