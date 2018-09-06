//
//  SAHelp.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SAHelp: UIViewController  , UITableViewDelegate  , UITableViewDataSource ,MFMessageComposeViewControllerDelegate ,MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tbl: UITableView!
    
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var TProducts : NSArray = []
    var elements: NSMutableArray = []
    var Values = [String]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadData()
        self.setupNavigationBarwithBack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.Values.count > 0){
            return  6
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!  HelpCell
        
        if(self.Values.count > 0 ){
            if(indexPath.row == 0){
                cell.lblTitle.text = "Call".localized
                cell.img.image = #imageLiteral(resourceName: "call")
            }
            if(indexPath.row == 1){
                cell.lblTitle.text =  "Email".localized
                cell.img.image = #imageLiteral(resourceName: "email")
            }
            if(indexPath.row == 2){
                cell.lblTitle.text = "SMS".localized
                cell.img.image = #imageLiteral(resourceName: "sms")
            }
            if(indexPath.row == 3){
                cell.lblTitle.text = "About Us".localized
                cell.img.image = #imageLiteral(resourceName: "about")
            }
            if(indexPath.row == 4){
                cell.lblTitle.text = "About Application".localized
                cell.img.image = #imageLiteral(resourceName: "about2")
                
            }
            if(indexPath.row == 5){
                cell.lblTitle.text = "Terms & Conditions".localized
                cell.img.image = #imageLiteral(resourceName: "terms")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            
            if let url = URL(string: "tel://\([self.Values[1])")
            {
                UIApplication.shared.openURL(url)
            }
        }
        if(indexPath.row == 1)
        {
            self.sendEmail()
        }
        if(indexPath.row == 2)
        {
            self.sms()
        }
        if(indexPath.row == 3)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.type = "about"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 4)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.type = "aboutApp"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if(indexPath.row == 5)
        {
            let vc:SAStaticPage = AppDelegate.storyboard.instanceVC()
            vc.type = "terms"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.tbl.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetConfig(){(response, err) in
                if((err) == nil)
                {
                    if let JSON = response.result.value as? NSDictionary
                    {
                        self.entries = JSON
                        for (key,value) in JSON
                        {
                            let keyy = key as! String
                            if (keyy == "telephone" || keyy == "email"){
                                self.Values.append(value as! String)
                            }
                        }
                        print( self.Values)
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
    
    func sms()
    {
        if (MFMessageComposeViewController.canSendText())
        {
            let number = self.Values[1] as! String
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.Values[0]])
            mail.setMessageBody("<p></p>", isHTML: true)
            
            present(mail, animated: true)
        }
        else {
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func btnSocial(_ sender: UIButton)
    {
        switch sender.tag {
        case 0:
            self.openSocial("instagram")
        case 1:
            self.openSocial("facebook")
        case 2:
            self.openSocial("twitter")
        case 3:
            //share
            share()
        default:
            return
        }
    }
    
    func share()
    {
        var msg = ""
        if(!Language.currentLanguage().contains("ar")){
            msg = " Alzahem Industries App Buy the latest products online, Check on Our Awesome Application here it is: https://goo.gl/S7g7Kd For more visit our website \n\n http://alzahem-industries.com/"
        }
        else{
            msg = " تطبيق الزاحم للصناعات لشراء منتجاتنا عبر التطبيق والاطلاع على الغاتالوج حمل التطبيق من الرابط: https://goo.gl/S7g7Kd \n\n او يمكنك زيارة موقعنا على الرابط http://alzahem-industries.com/"
        }
        
        var objectsToShare = [AnyObject]()
        objectsToShare.append(msg as AnyObject)
        
        if msg != nil
        {
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }
        else{
            print("There is nothing to share")
        }
    }
    
    func openSocial(_ key:String)
    {
        if(MyTools.tools.getConfigString(key) != "")
        {
            let urlString = MyTools.tools.getConfigString(key)
            let url = URL(string: urlString)
            let vc = SFSafariViewController(url: url!)
            present(vc, animated: true, completion: nil)
        }
        else{
            self.showOkAlert(title: "Error".localized, message: "link is not available right now".localized)
        }
    }
}
