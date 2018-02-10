//
//  UIImage+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2016. 11. 16..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import UIKit

extension UIImage {
    public func ipMask(color:UIColor) -> UIImage {
        var result: UIImage?
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
        if let c = UIGraphicsGetCurrentContext() {
            self.draw(in: rect)
            c.setFillColor(color.cgColor)
            c.setBlendMode(.sourceAtop)
            c.fill(rect)
            result = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return result ?? self
    }
    
    public func resize(size: CGSize, scale: CGFloat? = nil) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale ?? self.scale)
        self.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
    
    public func crop(withRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(withRect.size, false, self.scale)
        self.draw(at: CGPoint(x: -withRect.origin.x, y: -withRect.origin.y))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
    
    //MARK: - Class func
    class public func mergeImage(images: [UIImage]) -> UIImage? {
        guard let base = images.first else { return nil }
        let size = base.size
        UIGraphicsBeginImageContextWithOptions(size, false, base.scale)
        for image in images {
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    class public func image(withColor: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        withColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

