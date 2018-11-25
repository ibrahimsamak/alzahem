//
//  SACustomTextView.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

/// Language-aware field like `SACustomTextField`. Despite the "TextView" name it
/// subclasses `UITextField`, applying `ar_font`/`en_font` per language.
class SACustomTextView: UITextField
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
                self.font = MyTools.tools.appFontAr(size: ar_font)
            }
        }
    }
}
