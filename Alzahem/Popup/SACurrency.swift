
//
//  SACurrency.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/22/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import  UIKit
import SDWebImage

protocol GeneralProtocol
{
    func sendFilter(isFinist:Bool)
}

class SACurrency: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var delegate:GeneralProtocol?
    var TCategory : NSArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.LoadDataCategory()
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func LoadDataCategory()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetCurrencies()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSArray
                        {
                            self.TCategory = JSON
                            self.hideIndicator()
                            self.tbl.delegate = self
                            self.tbl.reloadData()
                            self.hideIndicator()
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
        else
        {
            self.showOkAlert(title: "Error".localized, message: "No Internet Connection".localized)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.TCategory.count>0 && section == 0)
        {
            return TCategory.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        
        if(self.TCategory.count>0)
        {
            let content = self.TCategory.object(at: indexPath.row) as AnyObject
            let name_en = content.value(forKey: "name_en") as! String
            let  name_ar  = content.value(forKey: "name_ar") as! String
            let  code  = content.value(forKey: "code") as! String
            let  id  = content.value(forKey: "id") as! Int
            cell.lblSub.text = code
          
            if(Language.currentLanguage().contains("ar")){
                cell.lblTitle.text = name_ar

            }
            else{
                cell.lblTitle.text = name_en
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let newIndexPath = NSIndexPath(row: indexPath.row, section: 0) as IndexPath
        let cell = tableView.cellForRow(at: indexPath)
        let content = self.TCategory.object(at: indexPath.row) as AnyObject
        let name_en = content.value(forKey: "name_en") as! String
        let  name_ar  = content.value(forKey: "name_ar") as! String
        let  code  = content.value(forKey: "code") as! String
        let  id  = content.value(forKey: "id") as! Int
        
        let count = RealmFunctions.shared.GetCountofCart()
        if(count > 0)
        {
            self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Warning change currency type leads to remove all items from cart".localized, okTitle: "Done".localized, cancelTitle: "Cancel".localized) { (success) in
                if(success)
                {
                    self.dismiss(animated: true)
                    {
                        RealmFunctions.shared.deleteAllRealm()
                        UserDefaults.standard.set(code, forKey: "CurrencyName")
                        UserDefaults.standard.set(id, forKey: "CurrencyId")
                        self.delegate?.sendFilter(isFinist: true)
                    }
                }
                else{
                    self.dismiss(animated: true)
                    {
                         self.delegate?.sendFilter(isFinist: false)
                    }
                }
            }
        }
        else{
            self.dismiss(animated: true)
            {
                //save to userdefault
                UserDefaults.standard.set(code, forKey: "CurrencyName")
                UserDefaults.standard.set(id, forKey: "CurrencyId")
                self.delegate?.sendFilter(isFinist: true)
            }
        }
    
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40.0
    }
}
