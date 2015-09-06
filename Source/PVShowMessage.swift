//
//  CL.swift
//  Pisma
//
//  Created by Patrik Vaberer on 7/20/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import Foundation
import UIKit


public protocol PVShowMessageDelegate {
    
    func didTapToMessage(identifier: AnyObject?)
}

typealias CL = PVShowMessage
public class PVShowMessage {
    
    private struct Static {
        
        static var onceToken: dispatch_once_t = 0
    }
    
    public enum InitialPosition {
        
        case Bottom
        case Top
    }
    
    
    public var delegate: PVShowMessageDelegate? = nil
    
    public static var cBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public static var cTextColor = UIColor.whiteColor()
    public static var cCornerRadius: CGFloat = 5
    public static var cFontName = UIFont.systemFontOfSize(CL.cFontSize).fontName
    public static var cFontSize: CGFloat = 17.0
    public static var cBorderWidth: CGFloat = 0
    public static var cBorderColor = UIColor.clearColor()
    public static var cPositionFromEdge: CGFloat = 10
    public static var cInitialPosition: InitialPosition = .Bottom
    public static var cExtraShowTimeForMessage: Double = 0.5
    public static var cAnimationDuration: Double = 1
    
    
    public static let instance = PVShowMessage()
    private var animations: [(text: String, identifier: AnyObject?)] = []
    private var concurrentAnimations = 0
    
    public func showMessage(text text: String) {
        
        showMessage(text: text, identifier: nil)
    }
    
    public func showMessage(text text: String, identifier: AnyObject?) {
        
        let pinTo = UIApplication.sharedApplication().delegate!.window!!
        if animations.isEmpty {
            
            animations.append((text: text, identifier: identifier))
            if concurrentAnimations == 0 {
                
                _ = PVView(pinTo: pinTo, text: text, identifier: identifier)
            }
        } else {
            
            animations.append((text: text, identifier: identifier))
        }
    }
    
    
    
    
    public func removeAllMessages() {
        
        
        animations = []
    }
    
    private static func delay(seconds seconds: Double, completion:()->()) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            completion()
        }
    }
}


class PVView: UIView {
    
    var width: NSLayoutConstraint? = nil
    var height: NSLayoutConstraint? = nil
    
    var identifier: AnyObject? = nil
    
    func changeSignIfNeeded(number: CGFloat) -> CGFloat {
        
        return CL.cInitialPosition == .Top ? -number : number
    }
    
    
    
    func handleTap(sender: UIGestureRecognizer) {
        
        if let delegate = CL.instance.delegate {
            
            delegate.didTapToMessage(identifier)
        }
    }
    
    convenience init (pinTo: AnyObject, text: String, identifier: AnyObject?) {
        self.init(frame:CGRectZero)
        
        self.identifier = identifier
        
        let tap = UITapGestureRecognizer(target: self, action: "handleTap:")
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
        
        CL.instance.concurrentAnimations++
        pinTo.addSubview(self)
        let conX = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: pinTo, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        conX.active = true
        
        let position = CL.cInitialPosition == .Bottom ? NSLayoutAttribute.Bottom : NSLayoutAttribute.Top
        
        let conY = NSLayoutConstraint(item: self, attribute: position, relatedBy: .Equal, toItem: pinTo, attribute: position, multiplier: 1.0, constant: changeSignIfNeeded(100))
        conY.active = true
        
        let l = PVLabel(pinTo: self)
        l.text = text
        pinTo.layoutIfNeeded()
        
        if frame.width > 320 {
            
            width = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300)
            width?.active = true
            pinTo.layoutIfNeeded()
        }
        
        if frame.height > UIScreen.mainScreen().bounds.height {
            
            height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.height - 30)
            height?.active = true
            pinTo.layoutIfNeeded()
        }
        
        let margin: CGFloat = changeSignIfNeeded(CL.cPositionFromEdge)
        conY.constant = -margin
        UIView.animateWithDuration(CL.cAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [.AllowUserInteraction, .CurveEaseOut], animations: {
            
            pinTo.layoutIfNeeded()
            }) { _ in
                
                CL.delay(seconds: CL.cExtraShowTimeForMessage, completion: {
                    
                    conY.constant = self.changeSignIfNeeded(10 + self.frame.height)
                    UIView.animateWithDuration(0.5, animations: {
                        
                        self.transform = CGAffineTransformMakeScale(0.3, 0.3)
                        pinTo.layoutIfNeeded()
                        
                        }, completion: { _ in
                            
                            self.removeFromSuperview()
                            CL.instance.concurrentAnimations--
                            
                            if !CL.instance.animations.isEmpty  {
                                
                                CL.instance.animations.removeAtIndex(0)
                            }
                            if !CL.instance.animations.isEmpty && CL.instance.concurrentAnimations == 0 {
                                let info = CL.instance.animations.first!
                                _ = PVView(pinTo: pinTo, text: info.text, identifier: info.identifier)
                            }
                    })
                })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settings()
    }
    
    func settings() {
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        backgroundColor = CL.cBackgroundColor
        layer.cornerRadius = CL.cCornerRadius
        layer.borderColor = CL.cBorderColor.CGColor
        layer.borderWidth = CL.cBorderWidth
    }
    
    
}
class PVLabel: UILabel {
    
    convenience init (pinTo: UIView) {
        self.init(frame:CGRectZero)
        
        
        pinTo.addSubview(self)
        
        let left = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: pinTo, attribute: .Leading, multiplier: 1, constant: 8)
        left.active = true
        
        let right = NSLayoutConstraint(item: pinTo, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 8)
        right.active = true
        
        let top = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: pinTo, attribute: .Top, multiplier: 1, constant: 8)
        top.active = true
        
        let bottom = NSLayoutConstraint(item: pinTo, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 8)
        bottom.active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        settings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settings()
    }
    
    func settings() {
        
        backgroundColor = UIColor.clearColor()
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textAlignment = .Center
        
        let f = UIFont(name: CL.cFontName, size: CL.cFontSize)
        if let f = f {
            
            font = f
        } else {
            
            font = UIFont(name: font.fontName, size: CL.cFontSize)
        }
        textColor = CL.cTextColor
    }
}