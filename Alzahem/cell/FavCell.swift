//
//  FavCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class FavCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var ViewStock: UIButton!
    @IBOutlet weak var llblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var MainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.MainView.layer.cornerRadius = 5
        self.MainView.layer.masksToBounds = true
        self.MainView.layer.borderWidth = 1
        self.MainView.layer.borderColor = MyTools.tools.colorWithHexString("979797").cgColor

        if(Language.currentLanguage().contains("ar")){
            llblPrice.textAlignment = .right
            lblTitle.textAlignment = .right
        }
        else{
            llblPrice.textAlignment = .left
            lblTitle.textAlignment = .left
        }
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
