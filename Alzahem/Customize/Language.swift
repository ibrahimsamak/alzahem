//
//  Language.swift
//  localizeExample
//
//  Created by Mostafa on 4/28/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import Foundation

/// Thin wrapper over the `AppleLanguages` user-default used to read and set the
/// app's active language code (e.g. "ar", "en").
class Language{

    /// The first entry of `AppleLanguages` — the language the app runs in.
    class func currentLanguage() -> String{

        let ns = UserDefaults.standard
        let langs = ns.value(forKey: "AppleLanguages") as! NSArray
        let firstLang = langs.firstObject as! String

        return firstLang
    }

    /// Makes `lang` the preferred language for the next launch.
    class func setAppLanguage(lang:String){
        
        let ns = UserDefaults.standard
        ns.setValue([lang, currentLanguage()], forKey: "AppleLanguages")
        ns.synchronize()
    }
    
    
    
}
