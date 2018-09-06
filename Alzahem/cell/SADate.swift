//
//  SADate.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/8/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SADate: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        if(Language.currentLanguage().contains("ar")){
            lblDate.textAlignment = .right
        }
        else{
            lblDate.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
