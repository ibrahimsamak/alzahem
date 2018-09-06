//
//  SASubCategory.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/8/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SASubCategory: UIViewController , UITableViewDelegate  , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var delegate:CategoryProtocol?
    var id = ""
    var name = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        self.setupNavigationBarwithBack()
        self.navigationItem.title = self.name
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return  self.Tcategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as!  CategoryCell
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        cell.lblTitle.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let content = self.Tcategory.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        let id = content.value(forKey: "id") as! Int
        
        let vc:SAProducts = AppDelegate.storyboard.instanceVC()
        vc.prodId = String(id)
        vc.fromHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    
    func loadData()
    {
        if MyTools.tools.connectedToNetwork()
        {
            self.showIndicator()
            MyApi.api.GetSubCategory(id: self.id)
                {(response, err) in
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
