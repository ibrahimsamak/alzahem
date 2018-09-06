//
//  SliderCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell , CPSliderDelegate
{
    @IBOutlet weak var slider: CPImageSlider!
    var imagesArray = [String]()
    var objects:NSArray = []
    var customeVC:UIViewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func config()
    {
        self.slider.delegate = self
        self.slider.autoSrcollEnabled = true
        self.slider.enableArrowIndicator = false
        self.slider.durationTime = 4
        for index in 0..<objects.count
        {
            let content = objects.object(at: index) as AnyObject
            let photo = content.value(forKey: "image_src") as! String
            self.imagesArray.append(photo)
        }
        self.slider.images = self.imagesArray

    }
    
    func sliderImageTapped(slider: CPImageSlider, index: Int)
    {
        let vc:SAProductsDetails = AppDelegate.storyboard.instanceVC()
        let content = self.objects.object(at: index) as AnyObject
        let id  = content.value(forKey: "id") as? Int ?? 0
        vc.id = id
        self.customeVC.navigationController?.pushViewController(vc, animated: true)
    }
}
