//
//  SACustomButton.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

/// Button that picks its title font by language: `ar_font` is applied when the
/// app is in Arabic, `en_font` otherwise. Both sizes are set in Interface Builder.
class SACustomButton: UIButton
{
    /// Font size used for the button title when the language is Arabic.
    @IBInspectable
    public var ar_font: CGFloat = 17 {
        didSet {
            if Language.currentLanguage().contains("ar"){
                self.titleLabel?.font = MyTools.tools.appFontAr(size: ar_font)
            }
        }
    }
    
    @IBInspectable
    public var en_font: CGFloat = 17  {
        didSet {
            if !Language.currentLanguage().contains("ar"){
                self.titleLabel?.font  = MyTools.tools.appFontEn(size: en_font)
            }
        }
    }
}
