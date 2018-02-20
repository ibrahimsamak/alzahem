//
//  RecentPrductCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

/// Compact collection-view cell for a product inside a horizontal carousel
/// (image, title, price, discount and sold-out overlays).
class RecentPrductCell: UICollectionViewCell {

    @IBOutlet weak var contentViewCell: UIView!
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var soldView: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentViewCell.dropShadow()
        
        if(Language.currentLanguage().contains("ar")){
            lblPrice.textAlignment = .right
            lblTitle.textAlignment = .right
        }
        else{
            lblPrice.textAlignment = .left
            lblTitle.textAlignment = .left
        }
    }
}
