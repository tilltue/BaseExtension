//
//  UIColor+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2018. 2. 5..
//

import UIKit

extension UIColor {
    convenience public init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha:alpha)
    }
    
    convenience public init(hexString: String) {
        var cString:String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(to:1)
            let rString = (cString as NSString).substring(to:2)
            let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to:2)
            let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to:2)
            
            var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        }else{
            log.debug("invalid UIColor Hex String")
            self.init(red: CGFloat(255) / 255.0, green: CGFloat(255) / 255.0, blue: CGFloat(255) / 255.0, alpha: CGFloat(1))
        }
    }
}
