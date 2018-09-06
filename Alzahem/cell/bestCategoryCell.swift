//
//  bestCategoryCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SDWebImage

class bestCategoryCell: UITableViewCell , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,  UICollectionViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var col: UICollectionView!
    @IBOutlet weak var btnNext: UIButton!
    var Products : NSArray = []
    var customeVC:UIViewController = UIViewController()

    override func awakeFromNib()
    {
        super.awakeFromNib()
        if(Language.currentLanguage().contains("ar")){
            btnNext.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else{

        }
    }

    func config()
    {
        self.col.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        self.col.register(UINib(nibName: "RecentPrductCell", bundle: nil), forCellWithReuseIdentifier: "RecentPrductCell")
        
        self.col.dataSource = self
        self.col.delegate = self
        self.col.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.Products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentPrductCell", for: indexPath) as! RecentPrductCell
        let content = self.Products.object(at: indexPath.row) as AnyObject
        let img = content.value(forKey: "image_src") as! String
        let name  = content.value(forKey: "name") as! String
        let price  = content.value(forKey: "price") as! String
        let in_stock  = content.value(forKey: "in_stock") as! Bool
        let regular_price  = content.value(forKey: "regular_price") as! String
        let on_sale  = content.value(forKey: "on_sale") as? Bool ?? false
        
        if(on_sale){
            cell.viewDiscount.isHidden = false
            cell.lblDiscount.text = String(Int(roundf(((Float(regular_price)!-Float(price)!)/Float(regular_price)!)*100)))+"%"
        }
        else{
            cell.viewDiscount.isHidden = true
            cell.lblDiscount.text = ""
        }
        
        
        cell.lblTitle.text = name
        cell.lblPrice.text = price+" "+MyTools.tools.getMyCurrencyCode()
        cell.img.sd_setImage(with: URL(string: img)!, placeholderImage: UIImage(named: "10000-2")!, options: SDWebImageOptions.refreshCached)
        
        if(in_stock)
        {
            cell.soldView.isHidden = true
        }
        else
        {
            cell.soldView.isHidden = false
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 5
        return CGSize(width: 104, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = self.Products.object(at: indexPath.row) as AnyObject
        let id  = content.value(forKey: "id") as? Int ?? 0
        let vc:SAProductsDetails = AppDelegate.storyboard.instanceVC()
        vc.id = id
        self.customeVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
