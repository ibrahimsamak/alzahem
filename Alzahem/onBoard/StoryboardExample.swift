//
//  StoryboardExampleViewController.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class StoryboardExampleViewController: UIViewController {

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

extension StoryboardExampleViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "space\(index).png")
        if index == 0 {
            if(Language.currentLanguage().contains("ar")){
                view?.titleLabel.text = "استعرض"
                view?.subTitleLabel.text = "العثور على منتج مناسب لأسلوب الموضة الخاص بك بسهولة عن طريق التمرير وانتقل."
            }
            else{
                view?.titleLabel.text = "EXPLORE".localized
                view?.subTitleLabel.text = "Find suitable product for your fashion style easily by swipe and scroll.".localized
            }
          
        } else if index == 1 {

            if(Language.currentLanguage().contains("ar")){
                view?.titleLabel.text = "ادفع هنا"
                view?.subTitleLabel.text = "الدفع عن طريق طرق الدفع المختلفةالمتوفرة لدينا."
            }
            else{
                view?.titleLabel.text = "PAY IT".localized
                view?.subTitleLabel.text = "Process payment for your purchased items with your lovely payment method.".localized
            }
            
           
        } else {
            if(Language.currentLanguage().contains("ar"))
            {
                view?.titleLabel.text = "سرعة في التوصيل"
                view?.subTitleLabel.text = "من خلال شريك التسليم المخصص لدينا  ستحصل على العناصر الخاصة بك بسرعة."
            }
            else
            {
                view?.titleLabel.text = "FAST DELIVERY".localized
                view?.subTitleLabel.text = "Within our dedicated delivery partner you’ll get your items fastly.".localized
            }
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay?
    {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
       
        if(Language.currentLanguage().contains("ar"))
        {
            overlay?.btn.setTitle("تخطي", for: .normal)
        }
        else
        {
            overlay?.btn.setTitle("Skip", for: .normal)
        }
        
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double)
    {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.buttonContinue.setTitle("Continue".localized, for: .normal)
         
            if(Language.currentLanguage().contains("ar"))
            {
                overlay.skip.setTitle("تخطي", for: .normal)
            }
            else
            {
                overlay.skip.setTitle("Skip", for: .normal)
            }
            
            overlay.skip.isHidden = false
        }
        else {
            overlay.buttonContinue.setTitle("Get Started!".localized, for: .normal)
            overlay.skip.isHidden = false
        }
    }
}
