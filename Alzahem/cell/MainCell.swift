//
//  MainCell.swift
//  Events
//
//  Created by ibrahim M. samak on 7/16/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(Language.currentLanguage().contains("ar")){
            lblSub.textAlignment = .right
            lblTitle.textAlignment = .right
        }
        else{
            lblSub.textAlignment = .left
            lblTitle.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
