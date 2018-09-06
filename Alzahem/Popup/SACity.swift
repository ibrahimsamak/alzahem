//
//  SACity.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/22/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

protocol CityProtocol
{
    func sendFilterCity(CityID:String , CityName:String,Price:String)
}


class SACity: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tbl: UITableView!
    var TCity:NSArray = []
    var delegate:CityProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbl.reloadData()
        self.tbl.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.TCity.count>0 && section == 0)
        {
            return TCity.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityCell
        
        if(self.TCity.count>0)
        {
            let content = self.TCity.object(at: indexPath.row) as AnyObject
            let city_name = content.value(forKey: "city_name") as! String
            
            cell.lblName.text = city_name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let newIndexPath = NSIndexPath(row: indexPath.row, section: 0) as IndexPath
        let cell = tableView.cellForRow(at: indexPath)
        let content = self.TCity.object(at: indexPath.row) as AnyObject
        let city_name = content.value(forKey: "city_name") as! String
        let id = content.value(forKey: "id") as! Int
        let price  = content.value(forKey: "price") as! String
        
        self.dismiss(animated: true)
        {
            //save to userdefault
            self.delegate?.sendFilterCity(CityID: String(id), CityName: city_name, Price: price)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40.0
    }
}
