//
//  SAMyProfile.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage
import GSImageViewerController

class SAMyProfile: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imageViewContent: UIView!
    @IBOutlet weak var viewHint: UIView!
    @IBOutlet weak var lbl1: SACustomLabel!
    @IBOutlet weak var lbl2: SACustomLabel!
    @IBOutlet weak var lbl3: SACustomLabel!
    
    var isChangeImage = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.setupView()
        
        if(Language.currentLanguage().contains("ar")){
            self.lbl1.textAlignment = .right
            self.lbl2.textAlignment = .right
            self.lbl3.textAlignment = .right
            self.lblName.textAlignment = .right
            self.lblUserName.textAlignment = .right
            self.lblPhone.textAlignment = .right
            self.lblEmail.textAlignment = .right

        }
        else{
            self.lbl1.textAlignment = .left
            self.lbl2.textAlignment = .left
            self.lbl3.textAlignment = .left
            self.lblName.textAlignment = .left
            self.lblUserName.textAlignment = .left
            self.lblPhone.textAlignment = .left
            self.lblEmail.textAlignment = .left

        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if ((UserDefaults.standard.object(forKey: "CurrentUser")) != nil)
        {
            self.viewHint.isHidden = true
            self.getUserProfile()
        }
        else
        {
            self.viewHint.isHidden = false
            self.showAlertWithOkButton("You have to login to edit your profile".localized) { (success) in
                let vc:SASignIn = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupView(){
        self.mainView.dropShadow()
        self.imageViewContent.dropShadow()
        
        //        let rectShape = CAShapeLayer()
        //        rectShape.bounds = self.mainView.frame
        //        rectShape.position = self.mainView.center
        //        rectShape.path = UIBezierPath(roundedRect: self.mainView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight , .topLeft], cornerRadii: CGSize(width: 7, height: 7)).cgPath
        //        self.mainView.layer.mask = rectShape
    }
    
    func getUserProfile(){
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetUserProfile(userId: MyTools.tools.getMyId())
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        let email = JSON["email"] as! String
                        let first_name = JSON["first_name"] as! String
                        let last_name = JSON["last_name"] as? String ?? ""
                        let username = JSON["username"] as! String
                        let img_Avatar = JSON["avatar_url"] as! String
                        let shipping = JSON["shipping"] as! NSDictionary
                        let phone = shipping.value(forKeyPath: "phone") as? String ?? ""

                        self.lblName.text = first_name+" "+last_name
                        self.lblPhone.text = phone
                        self.lblEmail.text = email
                        self.lblUserName.text = username
                        self.img.sd_setImage(with: URL(string: img_Avatar)!, placeholderImage: UIImage(named: "thumbuser")!, options: SDWebImageOptions.refreshCached)
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
    
    
    @IBAction func btnlogout(_ sender: UIButton)
    {
        self.showCustomAlert(okFlag: false, title: "Warning".localized, message: "Are you sure you want logout?".localized, okTitle: "Logout".localized, cancelTitle: "Cancel".localized) { (success) in
            if(success)
            {
                let ns = UserDefaults.standard
                ns.removeObject(forKey: "CurrentUser")
                UserDefaults.standard.removeObject(forKey: "Shipping")

//                UserDefaults.standard.removeObject(forKey: "CurrencyId")
//                UserDefaults.standard.removeObject(forKey: "CurrencyName")
//                UserDefaults.standard.removeObject(forKey: "slider")
                
                let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = vc
                appDelegate?.window??.makeKeyAndVisible()
                
            }
        }
    }
    
    @IBAction func upoadImage(_ sender: UIButton)
    {
        //open image
        let imageInfo   = GSImageInfo(image: self.img.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: self.view)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        self.present(imageViewer, animated: true, completion: nil)
    }
    
}
