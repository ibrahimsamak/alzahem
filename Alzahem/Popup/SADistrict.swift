//
//  SADistrict.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/22/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import  UIKit
import SDWebImage

protocol DistrictProtocol
{
    func sendFilter(DistrictID:String , DistrictName:String , Data:NSArray)
}

class SADistrict: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var delegate:DistrictProtocol?
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
            MyApi.api.GetCities(){(response, err) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        
        if(self.TCategory.count>0)
        {
            let content = self.TCategory.object(at: indexPath.row) as AnyObject
            let name = content.value(forKey: "name") as! String
            
            cell.lblName.text = name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.TCategory.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "ID") as! Int
        let data  = content.value(forKey: "data") as! NSArray
        
        self.dismiss(animated: true)
        {
            //save to userdefault
            self.delegate?.sendFilter(DistrictID: String(id), DistrictName: name,Data:data)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40.0
    }
}
