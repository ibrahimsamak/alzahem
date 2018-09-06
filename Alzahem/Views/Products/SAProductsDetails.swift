
//
//  SAProductsDetails.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import GSImageViewerController
class SAProductsDetails: UIViewController , CPSliderDelegate {
    
    func sliderImageTapped(slider: CPImageSlider, index: Int)
    {
        let url =  URL(string: self.imagesArr[index])!
        let key: String = SDWebImageManager.shared().cacheKey(for: url)!
        let cachedImage: UIImage? = SDImageCache.shared().imageFromDiskCache(forKey: key)
        
        if(cachedImage != nil)
        {
            let imageInfo   = GSImageInfo(image: cachedImage!, imageMode: .aspectFit)
            let transitionInfo = GSTransitionInfo(fromView: slider)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
            self.present(imageViewer, animated: true, completion: nil)
        }
    }
    
    
    @IBOutlet weak var viewStock: UIView!
    @IBOutlet weak var lblStock: UILabel!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var priceBlack: UILabel!
    @IBOutlet weak var priceRed: UILabel!
    @IBOutlet weak var initview: UIView!
    @IBOutlet weak var buyNow: UIView!
    @IBOutlet weak var addToCart: UIView!
    @IBOutlet weak var continue_shopping: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var slider: CPImageSlider!
    //    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var scrol: UIScrollView!
    @IBOutlet weak var OldView: UIView!
    
    var imagesArr = [String]()
    var id = 0
    var Price = ""
    var PriceOld = ""
    var btnBarBadge : MJBadgeBarButton!
    var on_sale = false
    var in_stock = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.customizeView()
        self.navigationItem.title = "PRODUCT DETAILS".localized
        self.loadData()
        print(self.id)
        
        if(Language.currentLanguage().contains("ar")){
            self.lblTitle.textAlignment = .right
            self.lblDetails.textAlignment = .right
        }
        else
        {
            self.lblTitle.textAlignment = .left
            self.lblDetails.textAlignment = .left
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setNavigationButton()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customizeView()
    {
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        
        self.continue_shopping.applyGradient(colours: colors, gradientOrientation: .vertical)
        self.continue_shopping.dropShadowLighBottom()
        
        self.buyNow.applyGradient(colours: colors, gradientOrientation: .vertical)
        self.buyNow.dropShadowLighBottom()
        self.addToCart.dropShadowLighBottom()
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetSingleProducts(id:String(id)){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let status = JSON["status"] as! String
                        if(status == "success")
                        {
                            let name = JSON["name"] as! String
                            let details = JSON["description"] as? String ?? ""
                            let price =  JSON["price"] as! String
                            let stock_quantity =  JSON["stock_quantity"] as! Int
                            let regular_price =  JSON["regular_price"] as! String
                            let images =  JSON["images"] as! NSArray
                            self.in_stock = JSON["in_stock"] as! Bool
                            self.on_sale = JSON["on_sale"] as! Bool
                            
                            if(!self.on_sale){
                                self.OldView.isHidden = true
                            }
                            else{
                                self.OldView.isHidden = false
                            }
                            if(self.in_stock)
                            {
                                self.lblStock.text = String(stock_quantity)+" in stock".localized
                                self.viewStock.backgroundColor = "2D3362".color
                            }
                            else
                            {
                                self.lblStock.text = "out of stock".localized
                                self.viewStock.backgroundColor = "E63828".color
                            }
                            
                            for index in 0..<images.count
                            {
                                let content = images.object(at: index) as AnyObject
                                let photo = content.value(forKey: "src") as! String
                                self.imagesArr.append(photo)
                            }
                            
                            
                            self.slider.delegate = self
                            self.slider.autoSrcollEnabled = true
                            self.slider.enableArrowIndicator = false
                            self.slider.durationTime = 4
                            self.slider.images = self.imagesArr
                            
                            self.Price = price
                            self.PriceOld = regular_price
                            self.initview.isHidden = true
                            self.lblTitle.text = name
                            self.lblDetails.text = details
                            self.priceRed.text = price+" "+MyTools.tools.getMyCurrencyCode()
                            self.priceBlack.text =  regular_price+" "+MyTools.tools.getMyCurrencyCode()
                            
                            if(Language.currentLanguage().contains("ar"))
                            {
                                let font = MyTools.tools.appFontAr(size: 14.0)
                                let font2 = MyTools.tools.appFontAr(size: 17)
                                let height = self.lblDetails.text?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 40, font:font)
                                let height2 = self.lblTitle.text?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 40, font:font2)
                                let h =  500 + height! + height2!
                                self.scrol.contentSize.height = h+100
                            }
                            else
                            {
                                let font = MyTools.tools.appFontEn(size: 14.0)
                                let font2 = MyTools.tools.appFontEn(size: 17)
                                let height = self.lblDetails.text?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 40, font:font)
                                let height2 = self.lblTitle.text?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 40, font:font2)
                                let h =  500 + height! + height2!
                                self.scrol.contentSize.height = h+100
                            }
                            print(self.scrol.contentSize.height)
                        }
                        else
                        {
                            self.hideIndicator()
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
    @IBAction func btnFavAction(_ sender: UIButton)
    {
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                MyApi.api.AddFav(user_id: MyTools.tools.getMyId(), product_id: String(self.id))
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as! String
                            if(status == "success")
                            {
                                self.btnFav.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
                                self.showOkAlert(title: "Success".localized, message: JSON["msg"] as! String)
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
    
    @IBAction func btnShare(_ sender: Any)
    {
        let cachedImage: UIImage? = UIImage()
        let msg = self.lblTitle.text!+"\n\n"+"For more download alzahem-industries App. للمزيد حمل تطبيق زونيا \n\n www.alzahem-industries.com"
        share(shareText: msg ,shareImage:cachedImage)
    }
    
    func share(shareText:String?,shareImage:UIImage?){
        
        var objectsToShare = [AnyObject]()
        
        if let shareTextObj = shareText{
            objectsToShare.append(shareTextObj as AnyObject)
        }
        
        if let shareImageObj = shareImage{
            objectsToShare.append(shareImageObj)
        }
        
        if shareText != nil 
        {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }
        else{
            print("There is nothing to share")
        }
    }
    
    
    @IBAction func buyNow(_ sender: UIButton)
    {
        if(self.in_stock)
        {
            let CartItem = RCart()
            var img = ""
            
            if(self.imagesArr.count>0)
            {
                img = self.imagesArr.first!
            }
            
            
            CartItem.d_price = Float(self.Price)!
            CartItem.d_priceOld = Float(self.PriceOld)!
            CartItem.d_total = Float(self.Price)!
            CartItem.f_rate = 1.0
            CartItem.i_amount = 1
            CartItem.s_image = img
            CartItem.d_weight = ""
            CartItem.pk_i_id = String(self.id)
            CartItem.s_name = lblTitle.text!
            CartItem.s_desc = lblDetails.text!
            CartItem.on_sale = self.on_sale
            
            RealmFunctions.shared.AddUserToRealm(newCart: CartItem)
            //go to cart VC
            
            let vc:SACartVC = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "There is no quantity of this product".localized)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton)
    {
        if(self.in_stock)
        {
            let CartItem = RCart()
            var img = ""
            
            if(self.imagesArr.count>0)
            {
                img = self.imagesArr.first!
            }
            
            
            CartItem.d_price = Float(self.Price)!
            CartItem.d_priceOld = Float(self.PriceOld)!
            CartItem.d_total = Float(self.Price)!
            CartItem.f_rate = 1.0
            CartItem.i_amount = 1
            CartItem.s_image = img
            CartItem.d_weight = ""
            CartItem.pk_i_id = String(self.id)
            CartItem.s_name = lblTitle.text!
            CartItem.s_desc = lblDetails.text!
            CartItem.on_sale = self.on_sale
            
            RealmFunctions.shared.AddUserToRealm(newCart: CartItem)
            self.btnBarBadge.badgeValue = String(RealmFunctions.shared.GetCountofCart())
            self.showOkAlert(title: "Success".localized, message: "Added to Cart Successfully".localized)
            //go to cart VC
        }
        else
        {
            self.showOkAlert(title: "Error".localized, message: "There is no quantity of this product".localized)
        }
    }
    
    @IBAction func continueShopping(_ sender: UIButton)
    {
        let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
        vc.selectedIndex = 2
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = vc
        appDelegate?.window??.makeKeyAndVisible()
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
