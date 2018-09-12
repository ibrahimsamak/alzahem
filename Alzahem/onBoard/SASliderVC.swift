//
//  SASliderVC.swift
//  Alzahem
//
//  Created by ibrahim M. samak on 8/2/18.
//  Copyright © 2018 ibrahim M. samak. All rights reserved.
//

import UIKit
import SwiftyOnboard

class SASliderVC: UIViewController {
    
    @IBOutlet weak var swiftyOnboard: SwiftyOnboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.backgroundColor = UIColor.white
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func handleSkip() {
        let vc:SAAdv = AppDelegate.storyboard.instanceVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
}

extension SASliderVC: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SliderAdvs.instanceFromNib() as? SliderAdvs
        view?.img.image = UIImage(named: "space\(index).png")
        view?.lblTitle.text = "EXPLORE".localized
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SliderContainer.instanceFromNib() as? SliderContainer
//        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
//        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! SliderContainer
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
//        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
//            overlay.buttonContinue.setTitle("Continue".localized, for: .normal)
//            overlay.skip.setTitle("Skip".localized, for: .normal)
//            overlay.skip.isHidden = false
        }
        else {
//            overlay.buttonContinue.setTitle("Get Started!".localized, for: .normal)
//            overlay.skip.isHidden = false
        }
    }
}
