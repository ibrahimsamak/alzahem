//
//  SAPayment.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/23/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.

import UIKit


extension Encodable {
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}


struct Item:Encodable
{
    var product_id: String = ""
    var product_name : String = ""
    var price : String = ""
    var quantity : String = ""
    var subtotal : String = ""
    var total : String = ""
    init(_product_id:String, _product_name:String ,_price:String ,_quantity:String ,_subtotal :String ,_total:String    )
    {
        self.product_id = _product_id
        self.product_name = _product_name
        self.price = _price
        self.quantity = _quantity
        self.subtotal = _subtotal
        self.total = _total
    }
    
    
    var dictionary: [String: String]
    {
        return ["product_id": product_id,
                "product_name": product_name,
                "price": price,
                "quantity": quantity,
                "total": total,
                "subtotal": subtotal]
    }
    
    var nsDictionary: NSDictionary
    {
        return dictionary as NSDictionary
    }
}


class SAPayment: UIViewController {

    @IBOutlet weak var lblProdCount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblDeliveryCose: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var MainvView2: UIView!
    @IBOutlet weak var MainvView1: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var lbl: UILabel!
    
    var payment_method = ""
    var note = ""
    var DataArray = [RCart]()
    var deliveryPrice = ""
    var total = 0.0
    var delivery = ""
    var isDoneOrder = false
    var isChecked = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
        
        
        self.MainvView1.layer.cornerRadius = 10
        self.MainvView1.layer.masksToBounds = true
        self.MainvView1.layer.borderWidth = 1
        self.MainvView1.layer.borderColor = MyTools.tools.colorWithHexString("4A4A4A").cgColor
        
        self.MainvView2.layer.cornerRadius = 10
        self.MainvView2.layer.masksToBounds = true
        self.MainvView2.layer.borderWidth = 1
        self.MainvView2.layer.borderColor = MyTools.tools.colorWithHexString("4A4A4A").cgColor
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "PAYMENT DETAILS".localized
        self.DataArray = RealmFunctions.shared.GetMyCartItems(s_devicetoken:"", s_devicetoken2: "").toArray(ofType: RCart.self)
        self.Total()
        self.delivery = MyTools.tools.getDeliveryPrice()
        if(self.delivery == "0" || self.delivery == nil)
        {
            self.lblDeliveryCose.text = "free delivery".localized
        }
        else
        {
            self.lblDeliveryCose.text = self.delivery+" "+MyTools.tools.getMyCurrencyCode()
        }
        self.lblProdCount.text = String(RealmFunctions.shared.GetCountofQtyCart())+" Product(s)".localized
        self.lblTotal.text = String(Double(self.delivery)!+Double(self.total))+" "+MyTools.tools.getMyCurrencyCode()
        
        
        if(Language.currentLanguage().contains("ar"))
        {
            lbl.textAlignment = .right
            arrow.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)

        }
        else{
            lbl.textAlignment = .left

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.isDoneOrder){
            self.navigationController?.popToRoot(animated: true)
        }
    }
    
    func Total()
    {
        for index in 0..<self.DataArray.count
        {
            self.total = self.total+Double((self.DataArray[index].d_price))*Double((self.DataArray[index].i_amount))
        }
        let totalRoung = String(format: "%.2f", self.total)
        self.lblSubtotal.text = totalRoung+" "+MyTools.tools.getMyCurrencyCode()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnchoosePayment(_ sender: UIButton)
    {
        if(sender.tag == 1){
            //Knet
            self.MainvView1.layer.cornerRadius = 10
            self.MainvView1.layer.masksToBounds = true
            self.MainvView1.layer.borderWidth = 1
            self.MainvView1.layer.borderColor = MyTools.tools.colorWithHexString("2DA4BD").cgColor
            
            self.MainvView2.layer.cornerRadius = 10
            self.MainvView2.layer.masksToBounds = true
            self.MainvView2.layer.borderWidth = 1
            self.MainvView2.layer.borderColor = MyTools.tools.colorWithHexString("4A4A4A").cgColor
            
            self.payment_method = "knet"
        }
        else{
          //cash
            
            self.MainvView1.layer.cornerRadius = 10
            self.MainvView1.layer.masksToBounds = true
            self.MainvView1.layer.borderWidth = 1
            self.MainvView1.layer.borderColor = MyTools.tools.colorWithHexString("4A4A4A").cgColor

            self.MainvView2.layer.cornerRadius = 10
            self.MainvView2.layer.masksToBounds = true
            self.MainvView2.layer.borderWidth = 1
            self.MainvView2.layer.borderColor = MyTools.tools.colorWithHexString("2DA4BD").cgColor
           
            self.payment_method = "cash"
        }
    }
    
    @IBAction func btnDone(_ sender: UIButton)
    {
        //request
        if(isChecked == false)
        {
            self.showOkAlert(title: "Error".localized, message: "you have to agree terms and condition to continue".localized)
        }
        else
        {
            var myArray : [NSDictionary] = []
            for index in 0..<self.DataArray.count
            {
                let data = self.DataArray[index]
                let item  = Item(_product_id:data.pk_i_id , _product_name: data.s_name, _price: String(data.d_price), _quantity: String(data.i_amount), _subtotal: String(data.d_total), _total: String(data.d_total))
                
                let dict = item.nsDictionary
                myArray.append(dict)
            }
            
            let ns = UserDefaults.standard
            let dict = ns.value(forKey: "Shipping") as! NSDictionary
            
            if MyTools.tools.connectedToNetwork()
            {
                self.showIndicator()
                let total = String(Double(self.delivery)!+Double(self.total))
                MyApi.api.PostPurchase(user_id: MyTools.tools.getMyId(), user_comments: self.note, total: total, payment_method: self.payment_method, payment_method_title: self.payment_method, line_items: myArray, shipping: dict)
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSDictionary
                        {
                            let status = JSON["status"] as! String
                            if(status != "error")
                            {
                                self.showOkAlertWithComp(title: "Success".localized, message: JSON["message"] as! String, completion: { (success) in
                                    if(success)
                                    {
                                        if(self.payment_method == "knet")
                                        {
                                            let link = JSON["knet_url"] as! String
                                            self.isDoneOrder = true
                                            self.navigationController?.popToRootViewControllerWithHandler
                                                {
                                                    RealmFunctions.shared.deleteAllRealm()
                                                    guard let url = URL(string: link) else {
                                                        return
                                                    }
                                                    if #available(iOS 10.0, *) {
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                    } else {
                                                        UIApplication.shared.openURL(url)
                                                    }
                                            }
                                        }
                                        else
                                        {
                                            let id = JSON["id"] as! Int
                                            let vc:SAInvoice = AppDelegate.storyboard.instanceVC()
                                            vc.ammount = String(total)
                                            vc.date = MyTools.tools.convertDateFormater2(date: Date())
                                            vc.invoiceID = String(id)
                                            vc.paymentMethod = self.payment_method
                                            RealmFunctions.shared.deleteAllRealm()
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                    }
                                })
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
    
    @IBAction func btnNext(_ sender: UIButton)
    {
        self.navigationController?.pop(animated: true)
    }
    
    
    @IBAction func isConfirmClick(_ sender: UIButton)
    {
        isChecked = !isChecked
        let img = isChecked ? #imageLiteral(resourceName: "checkedIcon") : #imageLiteral(resourceName: "unchecked")
        sender.setImage(img, for: .normal)
    }
    
    @IBAction func btnTerms(_ sender: UIButton)
    {
        let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
       
       vc.type = "terms"
    self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
