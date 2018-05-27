//
//  Localizer.swift
//  localizeExample
//
//  Created by Mostafa on 4/28/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit


/// Enables runtime language switching without restarting the app by method-
/// swizzling `Bundle.localizedString` and `UIApplication`'s layout direction so
/// both resolve against the currently selected language (see `Language`).
class Localizer
{
    /// Installs the swizzles. Called once at launch from `AppDelegate`.
    class func DoTheExchange()
    {
        ExchangeMethodForClasses(className: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.customLocalizedString(key:value:table:)))
        
        ExchangeMethodForClasses(className: UIApplication.self, originalSelector: #selector(getter: UIApplication.userInterfaceLayoutDirection), overrideSelector: #selector(getter: UIApplication.custom_userInterfaceLayoutDirection))
    }
}

extension Bundle{
    
    @objc func customLocalizedString(key: String, value:String?, table:String) -> String{
     
        let currentLang = Language.currentLanguage()
        var bundle = Bundle()
        
        if let path = Bundle.main.path(forResource: currentLang, ofType: "lproj"){
            bundle = Bundle(path: path)!
        }else{
            let path = Bundle.main.path(forResource: "Base", ofType: "lproj")
            bundle = Bundle(path: path!)!
            
            
        }
        
        return bundle.customLocalizedString(key: key, value: value, table: table)
    }
    
}


extension UIApplication
{
    @objc var custom_userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection{
        get{
            var direction = UIUserInterfaceLayoutDirection.leftToRight
            if Language.currentLanguage() == "ar" {
                direction = .rightToLeft
            }
            return direction
        }
    }
}


/// Swaps (or adds then swaps) an instance method with an override on the given
/// class — the shared primitive used to install the localization swizzles above.
func ExchangeMethodForClasses(className: AnyClass, originalSelector: Selector, overrideSelector: Selector)
{
    let originalMethod:Method = class_getInstanceMethod(className, originalSelector)!
    let overridMethod:Method = class_getInstanceMethod(className, overrideSelector)!
    
    if class_addMethod(className, originalSelector, method_getImplementation(overridMethod), method_getTypeEncoding(overridMethod)){
        
            class_replaceMethod(className, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }
    else
    {
        method_exchangeImplementations(originalMethod, overridMethod)
    }
}



