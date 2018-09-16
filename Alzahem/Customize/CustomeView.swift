//
//  CustomeView.swift
//  Cheaps
//
//  Created by ibrahim M. samak on 5/20/17.
//  Copyright © 2017 ibrahim M. samak. All rights reserved.
//

import Foundation
import UIKit

/// Rounded, red-bordered container view (corner radius 25) applied from
/// storyboards where a pill-shaped card is needed.
class CustomeView: UIView
{

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = MyTools.tools.colorWithHexString("ff4d4d").cgColor
    }
}
