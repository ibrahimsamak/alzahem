
//
//  SACustomLabel2.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/8/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

/// Like `SACustomLabel` but uses the app's secondary/bold font faces
/// (`appFontAr2` / `appFontEn2`) picked by language.
class SACustomLabel2: UILabel
{

    /// Font size used when the language is Arabic.
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
