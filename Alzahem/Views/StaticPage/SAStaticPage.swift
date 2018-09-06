

//
//  SAStaticPage.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAStaticPage: UIViewController {
    
    @IBOutlet weak var lblDesc: UILabel!
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.loadData()
        
    
    if(Language.currentLanguage().contains("ar")){
            lblDesc.textAlignment = .right
        }
        else{
            lblDesc.textAlignment = .left
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetTerms(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        if(self.type == "terms")
                        {
                            let items = JSON["terms_and_conditions"] as! NSDictionary
                            let content  =  items.value(forKey: "description") as! String
                            let title =   items.value(forKey: "name") as! String
                            self.navigationItem.title =  title

                            self.lblDesc.text = content
                        }
                        else if(self.type == "aboutApp")
                        {
                            let items = JSON["about_application"] as! NSDictionary
                            let content  =  items.value(forKey: "description") as! String
                            let title =   items.value(forKey: "name") as! String
                            self.navigationItem.title =  title
                            
                            self.lblDesc.text = content

                        }
                        else
                        {
                            let items = JSON["about_us"] as! NSDictionary
                            let content  =  items.value(forKey: "description") as! String
                            let title =   items.value(forKey: "name") as! String
                            self.navigationItem.title =  title
                           
                            self.lblDesc.text = content
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
