
//
//  SACustomLabel2.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/8/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

class SACustomLabel2: UILabel
{
    
    @IBInspectable
    public var ar_font: CGFloat = 17 {
        didSet {
            if Language.currentLanguage().contains("ar"){
                self.font = MyTools.tools.appFontAr2(size: ar_font)
            }
        }
    }
    
    @IBInspectable
    public var en_font: CGFloat = 17  {
        didSet {
            if !Language.currentLanguage().contains("ar"){
                self.font = MyTools.tools.appFontEn2(size: en_font)
            }
        }
    }
}
