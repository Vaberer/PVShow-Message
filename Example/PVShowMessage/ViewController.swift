//
//  ViewController.swift
//  PVPopUp
//
//  Created by Patrik Vaberer on 7/20/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PVShowMessageDelegate {
    
    private var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PVShowMessage.cBackgroundColor = .black
//        PVShowMessage.cBorderColor = .lightGray
//        PVShowMessage.cBorderWidth = 3
//        PVShowMessage.cCornerRadius = 0
//        PVShowMessage.cFontName = "HelveticeNeue-Light"
//        PVShowMessage.cFontSize = 40
//        PVShowMessage.cTextColor = .lightText
//        PVShowMessage.cPositionFromEdge = 150
//        PVShowMessage.cExtraShowTimeForMessage = 1
//        PVShowMessage.cInitialPosition = .top
//        PVShowMessage.cAnimationDuration = 0.8

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PVShowMessage.instance.delegate = self
    }

    @IBAction func bMessagePressed() {
        counter += 1
        PVShowMessage.instance.showMessage(text: "All data has been updated \(counter) times.", identifier: String(counter))
    }
    
    @IBAction func bRemoveStackPressed() {
        counter = 0
        PVShowMessage.instance.removeAllMessages()
    }

    func didTapToMessage(_ identifier: String?) {
        print("Tapped to message with identifier: \(String(describing: identifier))")
    }

}
