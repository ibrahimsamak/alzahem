//
//  SliderContainer.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import  SwiftyOnboard

/// Minimal SwiftyOnboard overlay exposing just the page control, loaded from its
/// nib and layered over the promotional slider pages.
class SliderContainer: SwiftyOnboardOverlay {

    @IBOutlet weak var contentControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SliderContainer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
