//
//  SAProducts.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import DGElasticPullToRefresh
class SAProducts: UIViewController , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate , UISearchBarDelegate , CategoryProtocol{
   
    func sendFilterCategory(catID: Int, isFinish: Bool) {
        if(isFinish){
            self.elements.removeAllObjects()
            self.Products = []
            self.TProducts = [:]
            self.prodId = String(catID)
            self.loadDataByCategory(1)
        }
    }
    
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var col: UICollectionView!
   
    var Products : NSArray = []
    var elements: NSMutableArray = []
    var TProducts : NSDictionary!
    var pageIndex = 1
    var isNewDataLoadingFilter: Bool = false
    var isSearch = false
    var prodId = ""
    var btnBarBadge : MJBadgeBarButton!
    var fromHome = false
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        self.navigationItem.title = "PRODUCTS".localized
        self.txtSearch.delegate = self
        self.txtSearch.clipsToBounds = true
        self.txtSearch.backgroundColor = UIColor.clear
        for s in self.txtSearch.subviews[0].subviews
        {
            if s is UITextField
            {
                s.layer.borderWidth = 1.0
                s.layer.cornerRadius = 5
                s.layer.borderColor = "BDBFBE".color.cgColor
            }
        }
        
        
        if(self.prodId != "")
        {
            self.loadDataByCategory(1)
        }
        else{
            let loadingView = DGElasticPullToRefreshLoadingViewCircle()
            loadingView.tintColor = MyTools.tools.colorWithHexString("68E9EF")
            self.col.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
                self?.elements.removeAllObjects()
                self?.Products = []
                self?.TProducts = [:]
                self?.elements.removeAllObjects()
                self?.loadData(1)
                self?.col.dg_stopLoading()
                },loadingView: loadingView)
            self.col.dg_setPullToRefreshFillColor(UIColor.clear)
            self.col.dg_setPullToRefreshBackgroundColor(self.col.backgroundColor!)
            self.loadData(1)
            
        }
    }
    
    
    deinit
    {
        if((self.col) != nil)
        {
            self.col.dg_removePullToRefresh()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setNavigationButton()
      
        if(self.fromHome)
        {
            self.navigationItem.leftBarButtonItem = nil
            self.setupNavigationBarwithBack()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.elements.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let img = content.value(forKey: "image_src") as! String
        let name  = content.value(forKey: "name") as! String
        let price  = content.value(forKey: "price") as! String
        let regular_price  = content.value(forKey: "regular_price") as! String
        let stock_quantity  = content.value(forKey: "stock_quantity") as! Int
        let in_stock  = content.value(forKey: "in_stock") as! Bool
        let on_sale  = content.value(forKey: "on_sale") as? Bool ?? false
        
        if(on_sale)
        {
            cell.ViewDiscount.isHidden = false
            cell.lblDiscount.text = String(Int(roundf(((Float(regular_price)!-Float(price)!)/Float(regular_price)!)*100)))+"%"
        }
        else
        {
            cell.ViewDiscount.isHidden = true
            cell.lblDiscount.text = ""
        }
        
        if(in_stock)
        {
            cell.lblstock.text = String(stock_quantity)+" in stock".localized
            cell.ViewStock.backgroundColor = "2D3362".color
        }
        else
        {
            cell.lblstock.text = "out of stock".localized
            cell.ViewStock.backgroundColor = "E63828".color
        }
        
        
        cell.btnFav.tag = indexPath.row
        cell.btnFav.addTarget(self, action: #selector(self.Fav(_:)), for: .touchUpInside)
        cell.btnFav.setImage(#imageLiteral(resourceName: "notfav"), for: .normal)
        cell.lblTitle.text = name
        cell.lblPrice.text = price+" "+MyTools.tools.getMyCurrencyCode()
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = collectionView.frame.width / 2 - 10
        return CGSize(width: size, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let content = self.elements.object(at: indexPath.row) as AnyObject
        let id  = content.value(forKey: "id") as! Int
        let vc:SAProductsDetails = AppDelegate.storyboard.instanceVC()
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadData(_ page:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetProducts(page:String(page)){(response, err) in
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
                        
                        self.col.delegate = self
                        self.col.dataSource = self
                        self.col.reloadData()
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
    
    
    func loadDataByCategory(_ page:Int)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetProductsByCateogryId(page: String(page), category: self.prodId)
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
                        
                        self.col.delegate = self
                        self.col.dataSource = self
                        self.col.reloadData()
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
    
    func loadDataByName(_ page:Int , _ text:String)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetProductsByName(page:String(page) , product_name:text){(response, err) in
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
                        
                        self.col.delegate = self
                        self.col.dataSource = self
                        self.col.reloadData()
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        //Cancel Button Clicked
        self.txtSearch.text = ""
        self.txtSearch.resignFirstResponder()
        self.elements.removeAllObjects()
        self.loadData(1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if((txtSearch.text?.count)! > 0)
        {
            self.elements.removeAllObjects()
            self.elements = []
            self.col.reloadData()
            UIView.animate(withDuration: 0.2){() -> Void in
                self.loadDataByName(1, self.txtSearch.text!)
            }
            self.txtSearch.resignFirstResponder()
            self.col.reloadData()
            
            self.isSearch = true
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if scrollView == self.col
        {
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if MyTools.tools.connectedToNetwork() {
                    if !isNewDataLoadingFilter
                    {
                        if(self.Products.count>0)
                        {
                            isNewDataLoadingFilter=true
                            self.pageIndex = self.pageIndex + 1
                            if(self.isSearch)
                            {
                                self.loadDataByName(self.pageIndex,txtSearch.text!)
                            }
                            else
                            {
                                if(self.prodId != "")
                                {
                                    self.loadDataByCategory(self.pageIndex)
                                }
                                else{
                                    self.loadData(self.pageIndex)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnFilter(_ sender: UIBarButtonItem)
    {
        let vc:SACategory = AppDelegate.storyboard.instanceVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func Fav(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            // add to favourite
            let index = sender.tag
            let content = self.elements.object(at: index) as AnyObject
            let id = content.value(forKey: "id") as! Int
            
            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                MyApi.api.AddFav(user_id: MyTools.tools.getMyId(), product_id: String(id))
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as! String
                            if(status == "success")
                            {
                                let indexpath = IndexPath(row: index, section: 0)
                                let cell = self.col.cellForItem(at: indexpath) as! ProductCell
                                cell.btnFav.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
//                                self.showOkAlert(title: "Success".localized, message: JSON["msg"] as! String)
                            }
                            else
                            {
                                self.showOkAlert(title: "Error".localized, message: JSON["msg"] as! String)
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
        else
        {
            self.showAlertWithOkButton("You have to login to add item to your favourite".localized) { (success) in
                let vc:SASignIn = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func setNavigationButton()
    {
        
        let basket = UIImageView(image:#imageLiteral(resourceName: "cart"))
        basket.frame = CGRect(x: CGFloat(5), y: CGFloat(7), width: CGFloat(20), height: CGFloat(20))
        let basketButton = UIButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(25), height: CGFloat(20)))
        basketButton.addSubview(basket)
        //  basketButton.backgroundColor = UIColor.white
        basketButton.addTarget(self, action: #selector(self.Cart(_:)), for: .touchUpInside)
        
        self.btnBarBadge = MJBadgeBarButton()
        self.btnBarBadge.setup(customButton: basketButton)
        self.btnBarBadge.shouldAnimateBadge = true
        self.btnBarBadge.badgeValue = String(RealmFunctions.shared.GetCountofCart())
        self.btnBarBadge.badgeOriginX = 15.0
        self.btnBarBadge.badgeOriginY = 0
        self.btnBarBadge.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = self.btnBarBadge
        
        
        self.navigationItem.setRightBarButtonItems([self.btnBarBadge], animated: true)
    }
    
    @objc func Cart(_ sender: UIButton)
    {
        let vc:SACartVC = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
