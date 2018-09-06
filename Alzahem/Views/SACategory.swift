//
//  SACategory.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/20/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

struct Category {
    let name : String
    var Sub : NSArray
}

protocol CategoryProtocol
{
    func sendFilterCategory(catID:Int,isFinish:Bool)
}


class SACategory: UIViewController , UITableViewDelegate  , UITableViewDataSource
{
    @IBOutlet weak var tbl: UITableView!
    var entries : NSDictionary!
    var Tcategory : NSArray = []
    var delegate:CategoryProtocol?
    var sections = [Category]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tbl.register(UINib(nibName: "CategoryCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
        let nib = UINib(nibName: "SACategoryHeader", bundle: nil)
        self.tbl.register(nib, forHeaderFooterViewReuseIdentifier: "SACategoryHeader")
        
        
        self.setupNavigationBarwithBack()
        self.navigationItem.title = "CATEGORY TITLES".localized
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.loadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currSection = sections[section]
        let title = currSection.name
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SACategoryHeader") as! SACategoryHeader
        cell.titleLabel.text = title
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return self.sections[section].name
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let items = self.sections[section].Sub
        return items.count
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as!  CategoryCell
        
        let items = self.sections[indexPath.section].Sub
        let content = items.object(at: indexPath.row) as AnyObject
        let name = content.value(forKey: "name") as! String
        cell.lblTitle.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let items = self.sections[indexPath.section].Sub
        let content = items.object(at: indexPath.row) as AnyObject
        
        let id = content.value(forKey: "category_id") as! Int
        print(id)
        self.navigationController?.popViewControllerWithHandler {
            self.delegate?.sendFilterCategory(catID: id, isFinish: true)
        }
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
            MyApi.api.GetCategories()
                {(response, err) in
                    if((err) == nil)
                    {
                        if let JSON = response.result.value as? NSArray
                        {
                            self.Tcategory = JSON
                            
                            for index in 0..<self.Tcategory.count
                            {
                                let obj = self.Tcategory.object(at: index) as! NSDictionary
                                for (key,value) in obj
                                {
                                    var name = ""
                                    var sub : NSArray = []
                                    let val = value
                                    let kkey = key as? String ?? ""
                                    if(kkey == "name")
                                    {
                                     name  = val as! String
                                    }
                                    if(kkey == "sub")
                                    {
                                        sub = val as! NSArray
                                    }
                                    let cat = Category(name:name , Sub: sub )
                                    self.sections.append(cat)
                                }
                            }
                            
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
