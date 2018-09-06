
//
//  SAVerifyCode.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SAVerifyCode: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtCode: HoshiTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
        
        if(Language.currentLanguage().contains("ar")){
            txtCode.textAlignment = .right
        }
        else{
            txtCode.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnSignUp(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostCheckCode(activecode: txtCode.text!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as! String
                        if(status != "error")
                        {
                            self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as! String, completion: { (success) in
                                if(success){
                                    // redirext to tabbar
                                    if ((UserDefaults.standard.value(forKey: "CurrencyId")) == nil)
                                    {
                                        UserDefaults.standard.set(1, forKey: "CurrencyId")
                                    }
                                    
                                    if ((UserDefaults.standard.value(forKey: "CurrencyName")) == nil)
                                    {
                                        UserDefaults.standard.set("KWD", forKey: "CurrencyName")
                                    }
                                    
                                    let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
                                    let appDelegate = UIApplication.shared.delegate
                                    appDelegate?.window??.rootViewController = vc
                                    appDelegate?.window??.makeKeyAndVisible()
                                }
                            })
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as! String)
                        }
                    }
                    else
                    {
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                    self.hideIndicator()
                }
                else
                {
                    self.hideIndicator()
                    self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
}
