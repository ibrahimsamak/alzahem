//
//  OrderCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblqty: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var contentViewCell: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentViewCell.dropShadow()
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            lblPrice.textAlignment = .right
            lblqty.textAlignment = .right
            lbldate.textAlignment = .right
            lblID.textAlignment = .right
            arrow.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else
        {
            lblPrice.textAlignment = .left
            lblqty.textAlignment = .left
            lbldate.textAlignment = .left
            lblID.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }
}
