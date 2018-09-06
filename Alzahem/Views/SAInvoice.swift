//
//  SAInvoice.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/23/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SAInvoice: UIViewController {

    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblAmmount: UILabel!
    @IBOutlet weak var lblInvoiceID: UILabel!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var lbl1: SACustomLabel!
    var invoiceID = ""
    var ammount = ""
    var date = ""
    var paymentMethod = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let colors = [UIColor(red: 0/255.0, green: 32/255.0, blue: 146/255.0, alpha: 1.0),UIColor(red: 26/255.0, green: 185/255.0, blue: 200/255.0, alpha: 1.0)]
        self.btn.applyGradient(colours: colors, gradientOrientation: .horizontal)
        self.btn2.applyGradient(colours: colors, gradientOrientation: .horizontal)
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "INVOICE".localized
        self.navigationItem.hidesBackButton = true
        
        self.lblAmmount.text = ammount+" "+MyTools.tools.getMyCurrencyCode()
        self.lblOrderDate.text = date
        self.lblPayment.text = paymentMethod
        self.lblInvoiceID.text = invoiceID
        
    
        if(Language.currentLanguage().contains("ar")){
            self.lbl1.textAlignment = .right
        }
        else{
            self.lbl1.textAlignment = .left
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func btnHome(_ sender: UIButton)
    {
        let vc:TTabBarViewController = AppDelegate.storyboard.instanceVC()
        vc.selectedIndex = 2
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = vc
        appDelegate?.window??.makeKeyAndVisible()
    }
    
    @IBAction func btnFinish(_ sender: UIButton)
    {
        // orders
        let vc:SAOrders = AppDelegate.storyboard.instanceVC()
    self.navigationController?.pushViewController(vc, animated: true)

    }
}
