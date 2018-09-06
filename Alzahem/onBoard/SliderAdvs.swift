//
//  SliderAdvs.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SwiftyOnboard

class SliderAdvs: SwiftyOnboardPage {
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var btn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(Language.currentLanguage().contains("ar")){
            lblTitle.textAlignment = .right
            lblDesc.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblDesc.textAlignment = .left

        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SliderAdvs", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
