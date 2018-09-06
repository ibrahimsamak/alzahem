//
//  OrderDetailsShipping.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class OrderDetailsShipping: UITableViewCell {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var lblInvoiceID: UILabel!
    @IBOutlet weak var lblStatusName: UILabel!
    
    @IBOutlet weak var lblPayment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.view1.layer.borderWidth = 1
        self.view1.layer.borderColor = MyTools.tools.colorWithHexString("F0F5F7").cgColor
        
        self.view2.layer.borderWidth = 1
        self.view2.layer.borderColor = MyTools.tools.colorWithHexString("F0F5F7").cgColor
        
        self.view3.layer.borderWidth = 1
        self.view3.layer.borderColor = MyTools.tools.colorWithHexString("F0F5F7").cgColor
        
        if(Language.currentLanguage().contains("ar"))
        {
            lblAddress.textAlignment = .right
            lblInvoiceID.textAlignment = .right
        }
        else
        {
            lblAddress.textAlignment = .left
            lblInvoiceID.textAlignment = .left
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
