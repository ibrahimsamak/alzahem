//
//  CartCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/21/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var llblPriceOld: UILabel!
    @IBOutlet weak var ViewStock: UIButton!
    @IBOutlet weak var llblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var cancelView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.MainView.layer.cornerRadius = 5
        self.MainView.layer.masksToBounds = true
        self.MainView.layer.borderWidth = 1
        self.MainView.layer.borderColor = MyTools.tools.colorWithHexString("979797").cgColor
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            lblTitle.textAlignment = .right
        }
        else
        {
            lblTitle.textAlignment = .left
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
