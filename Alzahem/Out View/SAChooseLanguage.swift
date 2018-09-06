//
//  SAChooseLanguage.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAChooseLanguage: UIViewController {

    @IBOutlet weak var btnAr: UIButton!
    @IBOutlet weak var btnEn: UIButton!
    var obj :NSArray = []
    var isBorder = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colorsEn = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        
        let colorsAr = [UIColor(red: 0/255.0,green: 185/255.0, blue: 200/255.0, alpha: 1.0),UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0)]

        
        self.btnAr.applyGradient(colours: colorsAr, gradientOrientation: .horizontal)
        self.btnEn.applyGradient(colours: colorsEn, gradientOrientation: .horizontal)
        
        
        Language.setAppLanguage(lang: "en-US")
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.btnEn.frame.size)
        gradient.colors = colorsEn.map { $0.cgColor }
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: self.btnEn.bounds, cornerRadius: 24).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.btnEn.layer.sublayers?.remove(at: 0)
        self.btnEn.setTitleColor(.black, for: .normal)
        self.btnEn.layer.addSublayer(gradient)
        self.isBorder = true
    }

    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupTransparentNavigationBar()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnChooseLanguage(_ sender: UIButton)
    {
        if(sender.tag == 0)
        {
            // En
            if(Language.currentLanguage().contains("ar"))
            {
                Language.setAppLanguage(lang: "en-US")
                let colorsEn = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
                
                let gradient = CAGradientLayer()
                gradient.frame =  CGRect(origin: CGPoint.zero, size: self.btnEn.frame.size)
                gradient.colors = colorsEn.map { $0.cgColor }
                
                let shape = CAShapeLayer()
                shape.lineWidth = 2
                shape.path = UIBezierPath(roundedRect: self.btnEn.bounds, cornerRadius: 24).cgPath
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = UIColor.clear.cgColor
                gradient.mask = shape
                
                self.btnEn.layer.sublayers?.remove(at: 0)
                self.btnEn.setTitleColor(.black, for: .normal)
                self.btnEn.layer.addSublayer(gradient)
                
                let colorsAr = [UIColor(red: 0/255.0,green: 185/255.0, blue: 200/255.0, alpha: 1.0),UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0)]
                
                //self.btnAr.layer.sublayers?.remove(at: 0)
                self.btnAr.applyGradient(colours: colorsAr, gradientOrientation: .horizontal)
                self.btnAr.setTitleColor(.white, for: .normal)
            }
        }
        else
        {
            if(!Language.currentLanguage().contains("ar"))
            {
                Language.setAppLanguage(lang: "ar")

                let colorsAr = [UIColor(red: 0/255.0,green: 185/255.0, blue: 200/255.0, alpha: 1.0),UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0)]

                let gradient = CAGradientLayer()
                gradient.frame =  CGRect(origin: CGPoint.zero, size: self.btnAr.frame.size)
                gradient.colors = colorsAr.map { $0.cgColor }
                
                let shape = CAShapeLayer()
                shape.lineWidth = 2
                shape.path = UIBezierPath(roundedRect: self.btnAr.bounds, cornerRadius: 24).cgPath
                shape.strokeColor = UIColor.black.cgColor
                shape.fillColor = UIColor.clear.cgColor
                gradient.mask = shape
                
                self.btnAr.layer.sublayers?.remove(at: 0)
                self.btnAr.setTitleColor(.black, for: .normal)
                self.btnAr.layer.addSublayer(gradient)
                
                let colorsEn = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
                
//                self.btnEn.layer.sublayers?.remove(at: 0)
                self.btnEn.applyGradient(colours: colorsEn, gradientOrientation: .horizontal)
                self.btnEn.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    
    func rootnavigationController()
    {
        if ((UserDefaults.standard.value(forKey: "CurrencyId")) == nil)
        {
            UserDefaults.standard.set(1, forKey: "CurrencyId")
        }
        
        if ((UserDefaults.standard.value(forKey: "CurrencyName")) == nil)
        {
            UserDefaults.standard.set("KWD", forKey: "CurrencyName")
        }
       
        if(Language.currentLanguage().contains("ar"))
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
   
        var font : UIFont = MyTools.tools.appFontEn(size: 18)
        if Language.currentLanguage().contains("ar") {
            font  = MyTools.tools.appFontAr(size: 18)
        }
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: font]

        guard let window = UIApplication.shared.keyWindow else { return }
        let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
        window.rootViewController = vc
    }
    
    @IBAction func btnGo(_ sender: UIButton)
    {
        self.rootnavigationController()
    }
    
}
