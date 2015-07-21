//
//  SecondVC.swift
//  PVPopUp
//
//  Created by Patrik Vaberer on 7/20/15.
//  Copyright (c) 2015 Patrik Vaberer. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PVShowMessage.instance.showMessage(text: "All data has been updated")
    }

}
