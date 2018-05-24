//
//  SACustomTextField.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/6/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

/// Text field that selects its font by language: `ar_font` for Arabic,
/// `en_font` otherwise, both set in Interface Builder.
class SACustomTextField: UITextField
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

    /// Font size used for non-Arabic languages.
    @IBInspectable
    public var en_font: CGFloat = 17  {
        didSet {
            // NOTE: uses the Arabic font/size here even in the English branch.
            if !Language.currentLanguage().contains("ar"){
                self.font = MyTools.tools.appFontAr(size: ar_font)
            }
        }
    }
}
