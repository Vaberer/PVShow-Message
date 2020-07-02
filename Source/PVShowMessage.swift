//
//  PVShowMessage.swift
//  App Toro Agency
//
//  Created by Patrik Vaberer on 7/20/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import Foundation
import UIKit

public protocol PVShowMessageDelegate {
    func didTapToMessage(_ identifier: String?)
}

typealias CL = PVShowMessage

@objcMembers
open class PVShowMessage: NSObject {

    public enum InitialPosition {
        case bottom
        case top
    }

    public var delegate: PVShowMessageDelegate? = nil
    public static var cBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
    public static var cTextColor = UIColor.white
    public static var cCornerRadius: CGFloat = 5
    public static var cFont = UIFont.systemFont(ofSize: 17)
    public static var cBorderWidth: CGFloat = 0
    public static var cBorderColor = UIColor.clear
    public static var cPositionFromEdge: CGFloat = 10
    public static var cInitialPosition: InitialPosition = .top
    public static var cExtraShowTimeForMessage: Double = 0.5
    public static var cAnimationDuration: Double = 1

    public static let instance = PVShowMessage()

    fileprivate var animations: [(text: String, identifier: String?)] = []
    fileprivate var concurrentAnimations = 0

    open func showMessage(text: String) {
        showMessage(text: text, identifier: nil)
    }

    open func showMessage(text: String, identifier: String?) {
        guard let pinToOptional = UIApplication.shared.delegate?.window,
            let pinTo = pinToOptional else {
                return
        }

        if animations.isEmpty {
            animations.append((text: text, identifier: identifier))
            if concurrentAnimations == 0 {
                _ = PVView(pinTo: pinTo, text: text, identifier: identifier)
            }
        } else {
            animations.append((text: text, identifier: identifier))
        }
    }

    open func removeAllMessages() {
        animations = []
    }

    fileprivate static func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
}

class PVView: UIView {

    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    var identifier: String?

    func changeSignIfNeeded(_ number: CGFloat) -> CGFloat {
        return CL.cInitialPosition == .top ? -number : number
    }

    @objc func handleTap(_ sender: UIGestureRecognizer) {
        CL.instance.delegate?.didTapToMessage(identifier)
    }

    convenience init (pinTo: AnyObject, text: String, identifier: String?) {
        self.init(frame: .zero)

        self.identifier = identifier
        let tap = UITapGestureRecognizer(target: self, action: #selector(PVView.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)

        CL.instance.concurrentAnimations += 1
        pinTo.addSubview(self)
        let conX = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: pinTo, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        conX.isActive = true

        let position = CL.cInitialPosition == .bottom ? NSLayoutConstraint.Attribute.bottom : NSLayoutConstraint.Attribute.top


        let conY = NSLayoutConstraint(item: self, attribute: position, relatedBy: .equal, toItem: pinTo, attribute: position, multiplier: 1.0, constant: changeSignIfNeeded(100))
        conY.isActive = true

        let l = PVLabel(pinTo: self)
        l.text = text
        pinTo.layoutIfNeeded()

        if frame.width > 320 {
            width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            width?.isActive = true
            pinTo.layoutIfNeeded()
        }

        if frame.height > UIScreen.main.bounds.height {
            height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height - 30)
            height?.isActive = true
            pinTo.layoutIfNeeded()
        }

        let margin: CGFloat = changeSignIfNeeded(CL.cPositionFromEdge)
        conY.constant = -margin
        UIView.animate(withDuration: CL.cAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [.allowUserInteraction, .curveEaseOut], animations: {

            pinTo.layoutIfNeeded()
        }) { _ in

            CL.delay(seconds: CL.cExtraShowTimeForMessage) {
                conY.constant = self.changeSignIfNeeded(10 + self.frame.height)
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    pinTo.layoutIfNeeded()

                }, completion: { _ in

                    self.removeFromSuperview()
                    CL.instance.concurrentAnimations -= 1

                    if !CL.instance.animations.isEmpty  {
                        CL.instance.animations.remove(at: 0)
                    }
                    if !CL.instance.animations.isEmpty && CL.instance.concurrentAnimations == 0 {
                        let info = CL.instance.animations.first!
                        _ = PVView(pinTo: pinTo, text: info.text, identifier: info.identifier)
                    }
                })
            }
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
        layer.borderColor = CL.cBorderColor.cgColor
        layer.borderWidth = CL.cBorderWidth
    }
}


class PVLabel: UILabel {

    convenience init (pinTo: UIView) {
        self.init(frame:CGRect.zero)

        pinTo.addSubview(self)

        let left = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: pinTo, attribute: .leading, multiplier: 1, constant: 8)
        left.isActive = true

        let right = NSLayoutConstraint(item: pinTo, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 8)
        right.isActive = true

        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: pinTo, attribute: .top, multiplier: 1, constant: 8)
        top.isActive = true

        let bottom = NSLayoutConstraint(item: pinTo, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 8)
        bottom.isActive = true
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
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        textAlignment = .center

        font = CL.cFont
        textColor = CL.cTextColor
    }

}
