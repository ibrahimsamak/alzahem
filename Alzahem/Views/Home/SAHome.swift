//
//  SAHome.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import BIZPopupView
import DGElasticPullToRefresh
import SwiftyOnboard

class SAHome: UIViewController , UITableViewDelegate  , UITableViewDataSource,GeneralProtocol
{
    
    func loadDataFilter()
    {
        var obj: NSArray = []
        if MyTools.tools.connectedToNetwork()
        {
            MyApi.api.GetHome()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status  = JSON["status"] as! String
                            if(status == "success")
                            {
                                let product_slider = JSON["product_slider"] as! NSArray
                                obj = product_slider
                                let ns = UserDefaults.standard
                                ns.setValue(obj, forKey: "slider")
                                ns.synchronize()
                                
                                let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = vc
                                appDelegate?.window??.makeKeyAndVisible()
                                
                            }
                            else
                            {
                            }
                        }
                    }
                    else
                    {
                        
                    }
            }
        }
        else
        {
        }
    }
    
    func sendFilter(isFinist: Bool) {
        if isFinist
        {
            loadDataFilter()
        }
    }
    
    @IBOutlet weak var slider: SwiftyOnboard!
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var TProducts : NSArray = []
    var elements: NSMutableArray = []
    var images = [String]()
    var imagesArr : NSArray = []
    var btnBarBadge : MJBadgeBarButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "bestCategoryCell", bundle: nil), forCellReuseIdentifier: "bestCategoryCell")
        self.tbl.register(UINib(nibName: "HomeProductCell", bundle: nil), forCellReuseIdentifier: "HomeProductCell")
        self.tbl.register(UINib(nibName: "HomeProductCell2", bundle: nil), forCellReuseIdentifier: "HomeProductCell2")

        
        //self.tbl.register(UINib(nibName: "NewSliderCell", bundle: nil), forCellReuseIdentifier: "NewSliderCell")
        
        self.setNavigationButton()
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = MyTools.tools.colorWithHexString("68E9EF")
        self.tbl.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self?.loadDataFilter()
            self?.tbl.dg_stopLoading()
            }, loadingView: loadingView)
        self.tbl.dg_setPullToRefreshFillColor(UIColor.clear)
        self.tbl.dg_setPullToRefreshBackgroundColor(self.tbl.backgroundColor!)
        self.loadData()
        
        self.imagesArr = MyTools.tools.getslider()
       
        self.slider.style = .light
        self.slider.delegate = self
        self.slider.dataSource = self
        self.slider.backgroundColor = UIColor.clear
    }
    
    deinit
    {
        if((self.tbl) != nil)
        {
            self.tbl.dg_removePullToRefresh()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationButton()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.Tcategory.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bestCategoryCell", for: indexPath) as!  bestCategoryCell
            
            cell.Products = self.TProducts
            cell.config()
            cell.customeVC = self
            cell.btnNext.addTarget(self, action: #selector(self.GoToProducts(_:)), for: .touchUpInside)
            return cell
        }
        else
        {
            if(indexPath.row % 2 == 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell2", for: indexPath) as!  HomeProductCell2
                let content = self.Tcategory.object(at: indexPath.row - 1) as AnyObject
                
                let name = content.value(forKey: "name") as? String ?? ""
                let img = content.value(forKey: "image_src") as? String ?? ""
                
                cell.lblTitle.text = name
                cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeProductCell", for: indexPath) as!  HomeProductCell
                let content = self.Tcategory.object(at: indexPath.row - 1) as AnyObject
                
                let name = content.value(forKey: "name") as? String ?? ""
                let img = content.value(forKey: "image_src") as? String ?? ""
                
                cell.lblTitle.text = name
                cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row > 0)
        {
            let content = self.Tcategory.object(at: indexPath.row - 1) as AnyObject
            let id = content.value(forKey: "id") as! Int
            let name = content.value(forKey: "name") as! String

            let vc:SASubCategory = AppDelegate.storyboard.instanceVC()
            vc.id = String(id)
            vc.name  = name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func GoToProducts(_ sender: UIButton)
    {
        let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
        vc.selectedIndex = 2
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = vc
        appDelegate?.window??.makeKeyAndVisible()

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return 225.0
        }
        else
        {
            return 159.0
        }
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetHome()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status  = JSON["status"] as! String
                            if(status == "success")
                            {
                                self.TProducts = JSON["product_new"] as! NSArray
                                self.Tcategory = JSON["category"] as! NSArray
                                self.imagesArr = MyTools.tools.getslider()

                                self.tbl.isHidden = false
                                self.tbl.delegate = self
                                self.tbl.dataSource = self
                                self.tbl.reloadData()
                            }
                            else
                            {
                                self.showOkAlert(title: "Error".localized, message: "An Error occurred".localized)
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
    
    @IBAction func btnCurrency(_ sender: UIBarButtonItem)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let smallViewController = storyboard.instantiateViewController(withIdentifier: "SACurrency") as! SACurrency
        
        smallViewController.delegate = self
        let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(250), height: CGFloat(400)))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        
        self.present(popupViewController!, animated: true, completion: nil)
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

extension SAHome: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int
    {
        if(self.imagesArr.count == 0 ){
            return 0
        }
        else{
            return self.imagesArr.count
        }
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage?
    {
        let view = SliderAdvs.instanceFromNib() as? SliderAdvs
        if(self.imagesArr.count > 0 )
        {
            let content = self.imagesArr.object(at: index) as AnyObject
            let img1 = content.value(forKey: "image_src") as! String
            let title  = content.value(forKey: "name") as! String
            let price  = content.value(forKey: "price") as! String
            let desc  = content.value(forKey: "short_description") as! String
            
            view?.img.sd_setImage(with: URL(string: img1)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
            view?.lblTitle.text = title
            view?.lblDesc.text = desc
            view?.btn.tag = index
            view?.btn.addTarget(self, action: #selector(self.openSlider(_:)), for: .touchUpInside)
            view?.lblPrice.text = price+" "+MyTools.tools.getMyCurrencyCode()
        }
        return view
    }
    
    @objc func openSlider(_ sender: UIButton)
    {
        let index = sender.tag
        let content = self.imagesArr.object(at: index) as AnyObject
        let id = content.value(forKey: "id") as! Int
        
        let vc:SAProductsDetails = AppDelegate.storyboard.instanceVC()
        vc.id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SliderContainer.instanceFromNib() as? SliderContainer
        overlay?.contentControl.numberOfPages = self.imagesArr.count
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! SliderContainer
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
    }
}



