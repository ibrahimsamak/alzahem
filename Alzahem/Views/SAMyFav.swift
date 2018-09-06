//
//  SAMyFav.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import  UIKit
import  SDWebImage
import  DGElasticPullToRefresh

class SAMyFav: UIViewController, UITableViewDelegate  , UITableViewDataSource {
    
    @IBOutlet weak var tbl: UITableView!
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var TProducts : NSArray = []
    var elements: NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "FavCell", bundle: nil), forCellReuseIdentifier: "FavCell")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = MyTools.tools.colorWithHexString("68E9EF")
        self.tbl.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.elements.removeAllObjects()
            self?.TProducts = []
            self?.elements.removeAllObjects()
            self?.loadData()
            if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
            {
                self?.tbl.dg_stopLoading()
            }
            },
                                                      loadingView: loadingView)
        self.tbl.dg_setPullToRefreshFillColor(UIColor.clear)
        self.tbl.dg_setPullToRefreshBackgroundColor(self.tbl.backgroundColor!)
        
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            self.loadData()
        }
        else
        {
            self.showAlertWithOkButton("You have to login to get your favourite items".localized) { (success) in
                let vc:SASignIn = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.Tcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as!  FavCell
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        
        let name = content.value(forKey: "name") as! String
        let in_stock = content.value(forKey: "in_stock") as! Bool
        let stock_quantity = content.value(forKey: "stock_quantity") as! Int
        let price = content.value(forKey: "price") as! String
        let img = content.value(forKey: "image_src") as! String
        
        if(in_stock)
        {
            cell.lblStock.text = String(stock_quantity)+" in stock".localized
            cell.ViewStock.backgroundColor = "2D3362".color
        }
        else
        {
            cell.lblStock.text = "out of stock".localized
            cell.ViewStock.backgroundColor = "E63828".color
        }
        
        
        cell.btnDelete.backgroundColor = UIColor.clear
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.Delete(_:)), for: .touchUpInside)
        cell.llblPrice.text = price+" "+MyTools.tools.getMyCurrencyCode()
        cell.lblTitle.text = name
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        
        let id = content.value(forKey: "id") as! Int
        let vc:SAProductsDetails = AppDelegate.storyboard.instanceVC()
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 143.0
    }
    
    @objc func Delete(_ sender: UIButton)
    {
        // go to provider profile
        let index = sender.tag
        let content = self.Tcategory.object(at: index) as AnyObject
        let id = content.value(forKey: "id") as! Int
        
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.RemoveFav(user_id:MyTools.tools.getMyId(),product_id:String(id))
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as! String
                        if(status == "success")
                        {
                            self.showOkAlert(title: "Success".localized, message: JSON["msg"] as! String)
                        }
                        else
                        {
                            self.showOkAlert(title: "Error".localized, message: JSON["msg"] as! String)
                        }
                        self.loadData()
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
    
    deinit
    {
        if((self.tbl) != nil)
        {
            self.tbl.dg_removePullToRefresh()
        }
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetFav(user_id:MyTools.tools.getMyId())
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSArray
                    {
                        self.Tcategory = JSON                 
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
