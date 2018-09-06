//
//  SASignIn.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SASignIn: UIViewController {

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtPassword: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
        
        if(Language.currentLanguage().contains("ar")){
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
        }
        else{
            txtEmail.textAlignment = .left
            txtPassword.textAlignment = .left
        }
    }
    
    @IBAction func btnSignIn(_ sender: UIButton) {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostLoginUser(username: txtEmail.text!, pass: txtPassword.text!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as! String
                        
                        if(status != "error")
                        {
                            let UserArray = JSON["user"] as? NSDictionary
                            let user_status_note = UserArray?.value(forKey: "user_status_note") as! String
                            
                            if(user_status_note == "not-verified")
                            {
                                let vc:SAVerifyCode = AppDelegate.storyboard.instanceVC()
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else
                            {
                                let ns = UserDefaults.standard
                                let CurrentUser:NSDictionary =
                                    [
                                        "id":UserArray?.value(forKey: "id") as! Int,
                                        "access_token":UserArray?.value(forKey: "user_token") as! String,
                                        "type": UserArray?.value(forKey: "role") as! String,
                                        "user_currency": UserArray?.value(forKey: "user_currency") as! String
                                    ]
                                ns.setValue(CurrentUser, forKey: "CurrentUser")
                                ns.synchronize()
                                
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

    @IBAction func btnForget(_ sender: Any)
    {
        let vc:SAForgetPassword = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any)
    {
        let vc:SASignUp = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
