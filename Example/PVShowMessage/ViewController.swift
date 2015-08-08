//
//  ViewController.swift
//  PVPopUp
//
//  Created by Patrik Vaberer on 7/20/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PVShowMessageDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PVShowMessage.cBackgroundColor = UIColor.blackColor()
//        PVShowMessage.cBorderColor = UIColor.lightGrayColor()
//        PVShowMessage.cBorderWidth = 3
//        PVShowMessage.cCornerRadius = 0
//        PVShowMessage.cFontName = "HelveticeNeue-Light"
//        PVShowMessage.cFontSize = 40
//        PVShowMessage.cTextColor = UIColor.lightTextColor()
//        PVShowMessage.cPositionFromEdge = 150
//        PVShowMessage.cExtraShowTimeForMessage = 1
//        PVShowMessage.cInitialPosition = .Top
//        PVShowMessage.cAnimationDuration = 1.5
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PVShowMessage.instance.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        PVShowMessage.instance.showMessage(text: "All data has been updated\nYou have fresh data")
    }
    
    var counter = 0
    @IBAction func bMessagePressed() {
        
        PVShowMessage.instance.showMessage(text: "All data has been updated \(++counter) times.", identifier: counter)
    }
    
    @IBAction func bRemoveStackPressed() {
        
        counter = 0
        PVShowMessage.instance.removeAllMessages()
    }
    
    
    func didTapToMessage(identifier: AnyObject?) {
        
        println("Tapped to message with identifier: \(identifier)")
    }
}