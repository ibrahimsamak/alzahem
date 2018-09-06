//
//  SAOrderDetails.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SAOrderDetails: UIViewController , UITableViewDelegate  , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var TShipping : NSDictionary!
    var Tcategory : NSArray = []
    var orderID = ""
    var currency = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "OrderDetailsCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsCell")
        
        self.tbl.register(UINib(nibName: "OrderDetailsShipping", bundle: nil), forCellReuseIdentifier: "OrderDetailsShipping")
        
        self.tbl.register(UINib(nibName: "SADate", bundle: nil), forCellReuseIdentifier: "SADate")
        
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "ORDER DETAILS".localized
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Tcategory.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsShipping", for: indexPath) as!  OrderDetailsShipping
            
            if(self.entries != nil){
                let content = self.entries!
                let status  = content.value(forKey: "status") as! String
                let total  = content.value(forKey: "total") as! String
                self.currency  = content.value(forKey: "currency") as! String
                let order_key  = content.value(forKey: "id") as! Int
                let payment_method  = content.value(forKey: "payment_method") as? String ?? ""
                let shipping = content.value(forKey: "shipping") as! NSDictionary
                
                
                switch status {
                case "Complete":
                    cell.img.image = #imageLiteral(resourceName: "blue")
                case "Processing":
                    cell.img.image = #imageLiteral(resourceName: "green")
                case "Canceled":
                    cell.img.image = #imageLiteral(resourceName: "red")
                case "New":
                    cell.img.image = #imageLiteral(resourceName: "yellow")
                case "Shipped":
                    cell.img.image = #imageLiteral(resourceName: "orange")
                case "Denied":
                    cell.img.image = #imageLiteral(resourceName: "brown")
                default:
                    cell.img.image = #imageLiteral(resourceName: "purple")
                }
                
                
                for (key,value) in shipping
                {
                    print("\(key) = \(value)")
                    let val = value as? String ?? ""
                    let kkey = key as? String ?? ""
                    if(kkey != "comments" && kkey != "price" && kkey != "city_id")
                    {
                        cell.lblAddress.text = cell.lblAddress.text!+(kkey.localized+" - "+val)+", "
                    }
                }
                
                cell.lblInvoiceID.text = String(order_key)
                cell.lblPrice.text = total+" "+self.currency
                cell.lblStatusName.text = status
                cell.lblPayment.text = payment_method
                self.tbl.separatorColor = UIColor.clear
            }
            return cell
        }
        else if(indexPath.row <= self.Tcategory.count)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as!  OrderDetailsCell
            if(self.Tcategory.count>0)
            {
                let content2 = self.entries!
                let content = self.Tcategory.object(at: indexPath.row-1) as AnyObject
                let product_name = content.value(forKey: "product_name") as! String
                let quantity = content.value(forKey: "quantity") as! String
                let price = content.value(forKey: "price") as! String
                let image = content.value(forKey: "image") as! String
                let currency  = content2.value(forKey: "currency") as! String
                
                cell.lblPrice.text = price+" "+currency
                cell.lblQty.text  = "Qty: ".localized+quantity
                cell.lblname.text = product_name
                cell.img.sd_setImage(with: URL(string: image)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
                self.tbl.separatorColor = "F1F5F4".color
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SADate", for: indexPath) as!  SADate
            if(self.entries != nil)
            {
                let content = self.entries!
                let date  = content.value(forKey: "date_created") as! String
                cell.lblDate.text = "DATE: ".localized+MyTools.tools.convertDateFormater10(date: date)
                self.tbl.separatorColor = UIColor.clear
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            return 267.0
        }
        else if(indexPath.row <= self.Tcategory.count)
        {
            return 129.0
        }
        else{
             return 50.0
        }
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetOrderDetails(OrderID: self.orderID)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON
                        self.Tcategory = JSON["line_items"] as! NSArray
                        self.TShipping = JSON["shipping"] as! NSDictionary
                        self.tbl.isHidden = false
                        self.tbl.delegate = self
                        self.tbl.dataSource = self
                        self.tbl.reloadData()
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
