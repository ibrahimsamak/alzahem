//
//  SliderCell.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 7/14/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit

/// Home-screen table cell that hosts an auto-scrolling image banner
/// (`CPImageSlider`). `config()` maps the `objects` payload into image URLs;
/// tapping a slide opens the corresponding product's details screen.
class SliderCell: UITableViewCell , CPSliderDelegate
{
    @IBOutlet weak var slider: CPImageSlider!
    var imagesArray = [String]()
    /// Raw slider payload (each entry carries an `image_src` and product `id`).
    var objects:NSArray = []
    /// Host controller used to push the product-details screen on tap.
    var customeVC:UIViewController = UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    /// Configures the banner: wires the delegate, enables auto-scroll and feeds
    /// it the image URLs extracted from `objects`.
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
