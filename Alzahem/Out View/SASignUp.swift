//
//  SASignUp.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SASignUp: UIViewController {

    
    @IBOutlet weak var btnview: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtPasswordConfirm: HoshiTextField!
    @IBOutlet weak var txtPassword: HoshiTextField!
    @IBOutlet weak var txtPhone: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var ttxtUserName: HoshiTextField!
    @IBOutlet weak var txtName: HoshiTextField!
    @IBOutlet weak var txtName2: HoshiTextField!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
        
        
        if(Language.currentLanguage().contains("ar")){
            txtEmail.textAlignment = .right
            txtPasswordConfirm.textAlignment = .right
            txtPassword.textAlignment = .right
            txtPhone.textAlignment = .right
            ttxtUserName.textAlignment = .right
            txtName.textAlignment = .right
            txtName2.textAlignment = .right
        }
        else{
            txtEmail.textAlignment = .left
            txtPasswordConfirm.textAlignment = .left
            txtPassword.textAlignment = .left
            txtPhone.textAlignment = .left
            ttxtUserName.textAlignment = .left
            txtName.textAlignment = .left
            txtName2.textAlignment = .left
        }
        
    }
    
    @IBAction func btnSignUp(_ sender: UIButton)
    {
            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                let dict = ["phone":self.txtPhone.text!] as! NSDictionary
                MyApi.api.PostNewUser(email: txtEmail.text!, username: ttxtUserName.text!, first_name: txtName.text!, last_name: txtName2.text!, password: txtPassword.text!,shipping:dict)
                    {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as! String
                            if(status != "error")
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as! String, completion: { (success) in
                                    if(success)
                                    {
                                        let UserArray = JSON["user"] as? NSDictionary
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
                                        
                                        
                                        let vc:SAVerifyCode = AppDelegate.storyboard.instanceVC()
                                        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    @IBAction func btnTerms(_ sender: UIButton)
    {
        let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
        vc.type = "terms"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        let vc:SASignIn = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
