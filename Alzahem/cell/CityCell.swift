//
//  CityCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/22/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        if(Language.currentLanguage().contains("ar"))
        {
            lblName.textAlignment = .right
        }
        else
        {
            lblName.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
