//
//  OrderDetailsCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var MainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.MainView.layer.cornerRadius = 5
        self.MainView.layer.masksToBounds = true
        self.MainView.layer.borderWidth = 1
        self.MainView.layer.borderColor = MyTools.tools.colorWithHexString("979797").cgColor
    
        if(Language.currentLanguage().contains("ar"))
        {
            lblPrice.textAlignment = .right
            lblQty.textAlignment = .right
            lblname.textAlignment = .right
        }
        else
        {
            lblPrice.textAlignment = .left
            lblQty.textAlignment = .left
            lblname.textAlignment = .left
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
