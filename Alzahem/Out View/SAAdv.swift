//
//  SAAdv.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/13/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAAdv: UIViewController {

    @IBOutlet weak var btn: SACustomButton!
    @IBOutlet weak var img: UIImageView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    if(Language.currentLanguage().contains("ar"))
        {
            self.btn.setTitle("تخطي", for: .normal)
        }
        else
        {
            self.btn.setTitle("skip", for: .normal)
        }
        
        UserDefaults.standard.setValue("1", forKey: "isFirst")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.loadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSkip(_ sender: UIButton) {
        
        let vc :SAChooseLanguage = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetAdvs(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        if(Language.currentLanguage().contains("ar"))
                        {
                            let img = JSON["imageAr"] as! String
                            self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
                        }
                        else
                        {
                            let img = JSON["imageEn"] as! String
                            self.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
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
