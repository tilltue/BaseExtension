//
//  UIView+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2016. 11. 16..
//  Copyright © 2016년 wade.hawk. All rights reserved.
//

import UIKit

// MARK: - Frame extension
extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue.x
            frame.origin.y = newValue.y
            self.frame = frame
        }
    }
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size.width = newValue.width
            frame.size.height = newValue.height
            self.frame = frame
        }
    }
    public var rect: CGRect {
        get {
            return self.frame
        }
        set {
            self.frame = newValue
        }
    }
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    public var centerY: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
}

// MARK: - View @IBInspectable
extension UIView {
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue}
    }
    @IBInspectable public var borderColor: UIColor {
        get { return UIColor(cgColor:layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            if newValue == 1 {
                layer.borderWidth = 1 / UIScreen.main.scale
            }else {
                layer.borderWidth = newValue
            }
        }
    }
}

// MARK: - View extension
extension UIView {
    public class func load(fromNibNamed: String, bundle : Bundle? = nil, withOwner: Any? = nil) -> UIView? {
        return UINib(nibName: fromNibNamed, bundle: bundle).instantiate(withOwner: withOwner, options: nil)[0] as? UIView
    }
    public func removeAllSubView() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    public func flip(completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.transform = CGAffineTransform(rotationAngle: 0)
        }, completion: completion)
    }
    public func flip(back: UIImage?, completion: (() -> Swift.Void)? = nil){
        let backView = UIImageView(frame: self.frame)
        backView.origin = CGPoint.zero
        backView.image = back
        self.addSubview(backView)
        UIView.transition(with: backView, duration: 0.2, options: .transitionFlipFromRight, animations: {
            self.isHidden = false
        }, completion: { _ in
            backView.removeFromSuperview()
        })
        UIView.transition(with: self, duration: 0.2, options: .transitionFlipFromRight, animations:nil, completion: { _ in
            self.isHidden = false
            completion?()
        })
    }
    public func takeSnapshotOfView() -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: self.width, height: self.height))
        self.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.width, height: self.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    //    func fadeHidden() {
    //        UIView.animate(withDuration: 0.5, animations: {
    //            self.alpha = 0
    //        }) { _ in
    //            self.alpha = 1
    //            self.isHidden = true
    //        }
    //    }
    //    func delayUserInterfaceEnable(_ duration: Double = 0.1) {
    //        self.isUserInteractionEnabled = false
    //        delay(delay: duration, closure: { [weak self] _ in
    //            self?.isUserInteractionEnabled = true
    //        })
    //    }
}

extension UIView {
    public func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

public protocol Shakeable { }

extension Shakeable where Self: UIView {
    public func shakeAnimation(){
        func makeShakeAnimation() -> CAAnimation {
            let shake = CAKeyframeAnimation(keyPath: "transform.translation")
            shake.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            shake.duration = 0.5
            shake.values = [-13,13,-13,13,-8,8-3,3,0]
            return shake
        }
        let shake = makeShakeAnimation()
        self.layer.add(shake, forKey: "shake")
    }
}

