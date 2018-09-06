//
//  CategoryCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            btn.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
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
