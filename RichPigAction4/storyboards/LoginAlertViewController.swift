//
//  LoginAlertViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/14.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class LoginAlertViewController: UIViewController {
    
    var buttonAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didTapCancelLogin(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

}
