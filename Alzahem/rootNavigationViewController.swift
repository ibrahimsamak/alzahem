//
//  rootNavigationViewController.swift
//  مجالس
//
//  Created by ibra on 11/24/16.
//  Copyright © 2016 ibra. All rights reserved.
//

import UIKit

/// Root navigation controller for the main (post-login) flow. On load it stores
/// itself on the `AppDelegate` (`mainRootNav`) so other code can push onto the
/// primary navigation stack.
class rootNavigationViewController: UINavigationController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if #available(iOS 10.0, *)
        {
            // Expose this navigation controller to the app delegate.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.mainRootNav = self
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
