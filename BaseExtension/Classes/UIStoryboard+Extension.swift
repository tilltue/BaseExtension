//
//  UIStoryboard+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 10. 17..
//

import Foundation
extension UIStoryboard {
    public class func VC(name: String, bundle: Bundle? = nil, withIdentifier: String) -> UIViewController {
        let board = UIStoryboard(name: name, bundle: bundle)
        return board.instantiateViewController(withIdentifier: withIdentifier)
    }
}
