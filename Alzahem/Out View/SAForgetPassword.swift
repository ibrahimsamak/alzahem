//
//  SAForgetPassword.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import TextFieldEffects

class SAForgetPassword: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: HoshiTextField!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupNavigationBarwithBack()
        
        if(Language.currentLanguage().contains("ar")){
            txtEmail.textAlignment = .right
        }
        else{
            txtEmail.textAlignment = .left
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnSend(_ sender: UIButton)
    {
        
        if MyTools.tools.connectedToNetwork()
        {
            if !MyTools.tools.validateEmail(candidate: txtEmail.text!) {
                self.showOkAlert(title: "Error".localized, message: "Please enter a valid email".localized)
            }
            else{
                
                
                self.showIndicator()
                MyApi.api.PostForgetPassword(email: txtEmail.text!)
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as! String
                            if(status == "success")
                            {
                                self.hideIndicator()
                                self.txtEmail.text = ""
                                self.showOkAlert(title: "Success".localized, message: JSON["msg"] as! String)
                            }
                            else
                            {
                                self.hideIndicator()
                                self.showOkAlert(title: "Error".localized, message: JSON["msg"] as! String)
                            }
                        }
                        else
                        {
                            self.hideIndicator()
                            self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                        }
                    }
                    else
                    {
                        self.hideIndicator()
                        self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
                    }
                }
            }
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    
}
