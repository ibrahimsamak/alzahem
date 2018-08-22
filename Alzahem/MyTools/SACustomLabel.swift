//
//  SACustomLabel.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

/// Label that chooses its font by language: `ar_font` for Arabic, `en_font`
/// otherwise, both configurable from Interface Builder.
class SACustomLabel: UILabel
{

    /// Font size used when the language is Arabic.
    @IBInspectable
    public var ar_font: CGFloat = 17 {
        didSet {
            if Language.currentLanguage().contains("ar"){
                self.font = MyTools.tools.appFontAr(size: ar_font)
            }
        }
    }
    
    @IBInspectable
    public var en_font: CGFloat = 17  {
        didSet {
            if !Language.currentLanguage().contains("ar"){
                self.font = MyTools.tools.appFontEn(size: en_font)
            }
        }
    }
}
