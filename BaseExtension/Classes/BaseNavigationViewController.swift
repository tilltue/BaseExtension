//
//  BaseNavigationViewController.swift
//  BaseExtension
//
//  Created by wade.hawk on 2016. 12. 7..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import UIKit

open class BaseNavigationViewController: UINavigationController {
    @IBInspectable var clearNavStyle: Bool = false
    @IBInspectable var statusBarStyle: Bool = true
    @IBInspectable var navTintColor: UIColor = UIColor.white
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusBarStyle ? .lightContent : .default
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor  = self.navTintColor
        if self.navTintColor.isEqual(UIColor.white) {
            self.navigationBar.tintColor = UIColor.white
        }
        if self.clearNavStyle {
            hideNavigationBar()
        }
    }
    fileprivate func hideNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
}
