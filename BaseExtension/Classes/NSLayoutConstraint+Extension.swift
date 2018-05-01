//
//  NSLayoutConstraint+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2018. 5. 1..
//

import Foundation

extension NSLayoutConstraint {
    @IBInspectable public var preciseConstant: Int {
        get {
            return Int(constant * UIScreen.main.scale)
        }
        set {
            constant = CGFloat(newValue) / UIScreen.main.scale
        }
    }
}
