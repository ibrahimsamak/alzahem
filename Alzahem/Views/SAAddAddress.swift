//
//  SAAddAddress.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/23/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import BIZPopupView

class SAAddAddress: UIViewController , DistrictProtocol , CityProtocol
{

    func sendFilter(DistrictID: String, DistrictName: String, Data: NSArray) {
        self.txtProvince.text = DistrictName
        self.DistrictId = DistrictID
        self.data = Data
    }
    
    func sendFilterCity(CityID: String, CityName: String, Price: String) {
        self.city_id = Int(CityID)!
        self.txtArea.text = CityName
        self.price = Price
    }
    

    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtProvince: UITextField!
    @IBOutlet weak var txtBlock: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtHouse: UITextField!
    @IBOutlet weak var txtFlat: UITextField!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var arrow: UIButton!
    
    
    var DistrictId = ""
    var city_id = 0
    var price = ""
    var data :NSArray = []
    var params: [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
        
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "DELIVERY ADDRESS".localized
        
        if(Language.currentLanguage().contains("ar")){
            txtArea.textAlignment = .right
            txtFlat.textAlignment = .right
            txtNote.textAlignment = .right
            txtBlock.textAlignment = .right
            txtHouse.textAlignment = .right
            txtStreet.textAlignment = .right
            txtProvince.textAlignment = .right
            arrow.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else{
            txtArea.textAlignment = .left
            txtFlat.textAlignment = .left
            txtNote.textAlignment = .left
            txtBlock.textAlignment = .left
            txtHouse.textAlignment = .left
            txtStreet.textAlignment = .left
            txtProvince.textAlignment = .left
        }
    }

    @IBAction func btnProvice(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let smallViewController = storyboard.instantiateViewController(withIdentifier: "SADistrict") as! SADistrict
        
        smallViewController.delegate = self
        let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(250), height: CGFloat(400)))
        popupViewController?.showDismissButton = true
        popupViewController?.enableBackgroundFade = true
        
        self.present(popupViewController!, animated: true, completion: nil)
    }
    
    @IBAction func btnCity(_ sender: UIButton)
    {
        if(self.DistrictId != "")
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let smallViewController = storyboard.instantiateViewController(withIdentifier: "SACity") as! SACity
            
            smallViewController.delegate = self
            smallViewController.TCity = self.data
            let popupViewController = BIZPopupViewController(contentViewController: smallViewController, contentSize: CGSize(width: CGFloat(250), height: CGFloat(400)))
            popupViewController?.showDismissButton = true
            popupViewController?.enableBackgroundFade = true
            self.present(popupViewController!, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func btnSave(_ sender: UIButton)
    {
        // save shipping data
        if(self.txtProvince.text?.count == 0 || self.txtBlock.text?.count == 0 || self.txtArea.text?.count == 0 ||  self.txtStreet.text?.count == 0 || self.txtFlat.text?.count == 0 || self.txtHouse.text?.count == 0 )
        {
            self.showOkAlert(title: "Error".localized, message: "All Fields are required".localized)
        }
        else{
            self.params = ["state_name":txtProvince.text! , "city_name":txtArea.text! , "city_id": self.city_id , "price":self.price , "block":txtBlock.text! , "street":txtStreet.text! , "home":txtHouse.text! , "department":txtFlat.text! , "comments":txtNote.text!]
            let ns = UserDefaults.standard
            ns.setValue(self.params, forKey: "Shipping")
            ns.synchronize()
            self.navigationController?.pop(animated: true)
        }
    }
    
    @IBAction func btnNext(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
}
