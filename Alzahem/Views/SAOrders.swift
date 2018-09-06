//
//  SAOrders.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAOrders:  UIViewController , UITableViewDelegate  , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    
    
    var Products : NSArray = []
    var elements: NSMutableArray = []
    var TProducts : NSDictionary!
    var pageIndex = 1
    var isNewDataLoadingFilter: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "ORDER HISTORY".localized
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        self.loadData(1)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as!  OrderCell
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let id  = content.value(forKey: "id") as! Int
        let status  = content.value(forKey: "status") as! String
        let status_type  = content.value(forKey: "status_type") as! String
        let quantity  = content.value(forKey: "quantity") as! String
        let total  = content.value(forKey: "total") as! String
        let currency  = content.value(forKey: "currency") as! String
        let order_key  = content.value(forKey: "order_key") as! String
        let date_created  = content.value(forKey: "date_created") as! String

        switch status_type {
        case "4":
            cell.img.image = #imageLiteral(resourceName: "blue")
        case "2":
            cell.img.image = #imageLiteral(resourceName: "green")
        case "5":
            cell.img.image = #imageLiteral(resourceName: "red")
        case "1":
            cell.img.image = #imageLiteral(resourceName: "yellow")
        case "3":
            cell.img.image = #imageLiteral(resourceName: "orange")
        case "6":
            cell.img.image = #imageLiteral(resourceName: "brown")
        default:
            cell.img.image = #imageLiteral(resourceName: "purple")
        }
        
        cell.lblID.text = "Order No. ".localized+String(id)
        cell.lblqty.text = "Qty: ".localized+quantity
        cell.lbldate.text = date_created
        cell.lblPrice.text = total+" "+currency
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let id  = content.value(forKey: "id") as! Int
        
        let vc:SAOrderDetails = AppDelegate.storyboard.instanceVC()
        vc.orderID = String(id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110.0
    }
    
    
    func loadData(_ page:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetOrders(page: String(page), consumer_id: MyTools.tools.getMyId())
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSArray
                        {
                            self.Products = JSON
                            
                            if (self.Products.count>0)
                            {
                                self.elements.addObjects(from: self.Products.subarray(with: NSMakeRange(0,self.Products.count)))
                                self.isNewDataLoadingFilter = false
                            }
                            else
                            {
                                self.isNewDataLoadingFilter = true
                            }
                            
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
 
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == self.tbl
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if MyTools.tools.connectedToNetwork() {
                    if !isNewDataLoadingFilter
                    {
                        if(self.Products.count>0)
                        {
                            isNewDataLoadingFilter=true
                            self.pageIndex = self.pageIndex + 1
                            self.loadData(self.pageIndex)
                        }
                    }
                }
            }
        }
    }
    
}
