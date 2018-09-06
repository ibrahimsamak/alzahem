//
//  SACartVC.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/21/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class SACartVC: UIViewController, UITableViewDelegate  , UITableViewDataSource  {
    
    @IBOutlet weak var MainvView: UIView!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var arrow: UIButton!
    
    
    var total = 0.0
    var DataArray = [RCart]()
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var FilteredArray : NSArray = []
    var elements: NSMutableArray = []
    var pageSize : Int = 10
    var pageIndex : Int = 1
    var qty = 1
    
    func Total()
    {
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
    }
    
    func TotalAfterDelete()
    {
        self.total = 0.0
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
    }
    
    func loadData()
    {
        var myId = ""
        self.DataArray = RealmFunctions.shared.GetMyCartItems(s_devicetoken: myId ,s_devicetoken2: "").toArray(ofType: RCart.self)
        if(self.DataArray.count>0)
        {
            self.hintView.isHidden = true
        }
        else
        {
            self.hintView.isHidden = false
        }
        
        self.tbl.reloadData()
        
        if(Language.currentLanguage().contains("ar"))
        {
            txtNote.textAlignment = .right
            lbl1.textAlignment = .right
            arrow.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else
        {
            txtNote.textAlignment = .left
            lbl1.textAlignment = .left
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "SHOPPING CART".localized
        
        
        self.MainvView.layer.cornerRadius = 5
        self.MainvView.layer.masksToBounds = true
        self.MainvView.layer.borderWidth = 1
        self.MainvView.layer.borderColor = "1F89B3".color.cgColor
        
        
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .vertical)
        
        self.loadData()
        self.Total()
        self.tbl.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataArray.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell

        cell.lblTitle.text = self.DataArray[indexPath.row].s_name
        let img = self.DataArray[indexPath.row].s_image as? String ?? ""
        let on_sale = self.DataArray[indexPath.row].on_sale
       
        if(img != "")
        {
            cell.img.sd_setImage(with: URL(string:img)!, placeholderImage: UIImage(named: "thumb")!, options: SDWebImageOptions.refreshCached)
        }
        else
        {
            cell.img.image = UIImage(named:"thumb")
        }
        
        cell.llblPrice.text = String(self.DataArray[indexPath.row].d_price)+" "+MyTools.tools.getMyCurrencyCode()
        cell.llblPriceOld.text = String(self.DataArray[indexPath.row].d_priceOld)+" "+MyTools.tools.getMyCurrencyCode()
        cell.txtQty.text = String(self.DataArray[indexPath.row].i_amount)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(DeleteAction(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.btnMinus.tag = indexPath.row
        cell.btnPlus.tag = indexPath.row
        cell.btnPlus.addTarget(self, action: #selector(self.Plus(_:)), for: .touchUpInside)
        cell.btnMinus.addTarget(self, action: #selector(self.Minus(_:)), for: .touchUpInside)
       
        if(on_sale)
        {
            cell.llblPriceOld.isHidden = false
            cell.cancelView.isHidden = false
        }
        else
        {
            cell.llblPriceOld.isHidden = true
            cell.cancelView.isHidden = true
        }
        
        return cell
    }
    
    @objc func Plus(_ sender: UIButton)
    {
        self.total = 0.0
        let index = sender.tag
        self.qty = self.qty + 1
        RealmFunctions.shared.UpdateAmmout(pk_i_id: self.DataArray[index].pk_i_id , i_ammount: self.qty)

        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
        
        let indexpath = IndexPath(row: index, section: 0)
        let cell = self.tbl.cellForRow(at: indexpath) as! CartCell
        cell.txtQty.text = String(self.qty)
    }
    
    @objc func Minus(_ sender: UIButton)
    {
        self.total = 0.0
        let index = sender.tag
        if(self.qty > 1)
        {
            self.qty = self.qty - 1
            RealmFunctions.shared.UpdateAmmout(pk_i_id: self.DataArray[index].pk_i_id , i_ammount: self.qty)
            for index in 0..<self.DataArray.count
            {
                self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
            }
            let totalRoung = String(format: "%.2f", self.total)
            self.lblTotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
            
            let indexpath = IndexPath(row: index, section: 0)
            let cell = self.tbl.cellForRow(at: indexpath) as! CartCell
            cell.txtQty.text = String(self.qty)
        }
    }
    
    
    @objc func DeleteAction(sender:UIButton)
    {
        let index = sender.tag
        let indexpath = IndexPath(row: index, section: 0)
        RealmFunctions.shared.deleteCartItem(pk_i_id: self.DataArray[index].pk_i_id)
        self.DataArray.remove(at: index)
        self.tbl.deleteRows(at: [indexpath], with: UITableViewRowAnimation.automatic)
        self.TotalAfterDelete()
        self.loadData()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 143.0
    }
    
    
    @objc func stepperValueChanged(stepper: GMStepper)
    {
        self.total = 0.0
        let index = stepper.tag
        RealmFunctions.shared.UpdateAmmout(pk_i_id: self.DataArray[index].pk_i_id , i_ammount: Int(stepper.value))
        self.loadData()
        
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblTotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
        
    }
    
    
    @IBAction func btnAddAddress(_ sender: UIButton)
    {
        //check if has address or not
        if ((UserDefaults.standard.value(forKey: "Shipping")) != nil)
        {
            self.showAlertWithVC("You have an address would you like to change it?".localized) { (success) in
                if(success)
                {
                    let vc:SAAddAddress = AppDelegate.storyboard.instanceVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else{
            let vc:SAAddAddress = AppDelegate.storyboard.instanceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnNext(_ sender: Any)
    {
        self.navigationController?.pop(animated: true)
    }
    
    @IBAction func btnCheckout(_ sender: UIButton)
    {
        
        
        if ((UserDefaults.standard.value(forKey: "CurrentUser")) != nil)
        {
            if ((UserDefaults.standard.value(forKey: "Shipping")) != nil)
            {
                var msg = ""
                
                let address = UserDefaults.standard.value(forKey: "Shipping") as! NSDictionary
                for (key,value) in address
                {
                    print("\(key) = \(value)")
                    let val = value as? String ?? ""
                    let kkey = key as? String ?? ""
                    if(kkey != "comments" && kkey != "price" && kkey != "city_id")
                    {
                        msg = msg+(kkey.localized+" - "+val)+", "
                    }
                }
                
                self.showCustomAlert(okFlag: true, title: "", message: "use your current address: ".localized+"\n"+msg, okTitle: "Update".localized, cancelTitle: "Use".localized) { (success) in
                    if(success){
                        let vc:SAAddAddress = AppDelegate.storyboard.instanceVC()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        var myArray : [NSDictionary] = []
                        
                        for index in 0..<self.DataArray.count
                        {
                            let data = self.DataArray[index]
                            let item  = Item(_product_id:data.pk_i_id , _product_name: data.s_name, _price: String(data.d_price), _quantity: String(data.i_amount), _subtotal: String(data.d_total), _total: String(data.d_total))
                            
                            let dict = item.nsDictionary
                            myArray.append(dict)
                        }
                        
                        if MyTools.tools.connectedToNetwork()
                        {
                            self.showIndicator()
                            MyApi.api.PostCheckCart(line_items: myArray)
                            {(response, err) in
                                if((err) == nil)
                                {
                                    if let JSON = response.result.value as? NSDictionary
                                    {
                                        let status = JSON["status_id"] as! String
                                        if(status == "1")
                                        {
                                            let vc:SAPayment = AppDelegate.storyboard.instanceVC()
                                            vc.note = self.txtNote.text!
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        else
                                        {
                                            self.showOkAlert(title: "Error".localized, message: JSON["message"] as! String)
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
                }

            }
            else{
                self.showAlertWithOkButton("You have to add delivered address".localized) { (success) in
                    let vc:SAAddAddress = AppDelegate.storyboard.instanceVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        else{
            self.showAlertWithOkButton("You have to login to add item to your cart".localized) { (success) in
                let vc:SASignIn = AppDelegate.storyboard.instanceVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
    func CheckProductAvailability()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetFav(user_id:MyTools.tools.getMyId()){(response, err) in
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
