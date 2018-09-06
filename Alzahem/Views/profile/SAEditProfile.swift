//
//  SAEditProfile.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import  TextFieldEffects
import SDWebImage

class SAEditProfile: UIViewController , UIActionSheetDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtPhone: HoshiTextField!
    @IBOutlet weak var txtEmail: HoshiTextField!
    @IBOutlet weak var txtLast: HoshiTextField!
    @IBOutlet weak var txtFirst: HoshiTextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtUserName: HoshiTextField!
    
    var isChangeImage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarwithBack()
        self.navigationItem.title =  "EDIT USER INFORMATION".localized
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
        
        self.getUserProfile()
        
        if(Language.currentLanguage().contains("ar")){
            txtLast.textAlignment = .right
            txtEmail.textAlignment = .right
            txtFirst.textAlignment = .right
            txtPhone.textAlignment = .right
            txtUserName.textAlignment = .right
        }
        else{
            txtLast.textAlignment = .left
            txtEmail.textAlignment = .left
            txtFirst.textAlignment = .left
            txtPhone.textAlignment = .left
            txtUserName.textAlignment = .left
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnUpload(_ sender: UIButton)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title:"Images".localized, message: "Please select the image source".localized, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel".localized, style: .cancel) { action -> Void in
            print("الغاء")
        }
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library".localized, style: .default)
        { action -> Void in
            //Todo Upload image from Library
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default)
        { action -> Void in
            //ToDo Upload image From Camera
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
            print("الكاميرا")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        actionSheetControllerIOS8.addAction(saveActionButton)
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad )
        {
            if let currentPopoverpresentioncontroller = actionSheetControllerIOS8.popoverPresentationController {
                actionSheetControllerIOS8.popoverPresentationController?.sourceView = self.view
                actionSheetControllerIOS8.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                actionSheetControllerIOS8.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }  
    }
    
    func UpdateProfile()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            let image = UIImageJPEGRepresentation(self.img.image!, 0.8) as? Data
            MyApi.api.PostEditUser(userId: MyTools.tools.getMyId(), file: image!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerEditedImage]
        picker.dismiss(animated: true)
        {
            let img = chosenImage as! UIImage?
            self.img.image = img
            self.UpdateProfile()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.isChangeImage = false
        picker.dismiss(animated: true, completion: nil)
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
//                        let phone = JSON["phone"] as? String ?? ""
                        let username = JSON["username"] as! String
                        let img_Avatar = JSON["avatar_url"] as! String
                        let shipping = JSON["shipping"] as! NSDictionary
                        let phone = shipping.value(forKeyPath: "phone") as? String ?? ""
                        
                        self.txtFirst.text = first_name
                        self.txtLast.text = last_name
                        self.txtPhone.text = phone
                        self.txtEmail.text = email
                        self.txtPhone.text = phone
                        self.txtUserName.text = username
                        self.txtUserName.isEnabled = false
                        self.txtEmail.isEnabled = false
//                        self.lblUserName.text = username
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
    
    @IBAction func btnUpdate(_ sender: UIButton)
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.PostUserUpdate(first_name: txtFirst.text!, last_name: txtLast.text!, phone: txtPhone.text!, email: txtEmail.text!)
            {(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
//                        self.showOkAlertWithComp(title: "", message: JSON["message"] as! String, completion: { (success) in
//                            if(success){
                                self.navigationController?.pop(animated: true)
                           // }
//                        })
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
