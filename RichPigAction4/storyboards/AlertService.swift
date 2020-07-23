//
//  File.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/14.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class AlertService {
    
    func alert(title: String, body: String, buttonTitle: String, completion: @escaping () -> Void) -> AlertViewController {
        let storyboard = UIStoryboard(name: "AlertStoryboard", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        alertVC.alertTitle = title
        alertVC.alertBody = body
        alertVC.actionButtonTitle = buttonTitle
        alertVC.buttonAction = completion
        return alertVC
    }
    
    func loginAlert() -> LoginAlertViewController {
        let storyboard = UIStoryboard(name: "LoginAlert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "LoginAlert") as! LoginAlertViewController
        return alertVC
    }
    
    func modifyAlert(complection: @escaping () -> Void) -> ModifyInfoAlertView {
        let storyboard = UIStoryboard(name: "ModifyInfoAlertView", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "modify") as! ModifyInfoAlertView
        
        
        alertVC.buttionAction = complection
        return alertVC
    }
    
    func modifyAlert2() -> Modify {
        let storyboard = UIStoryboard(name: "Modify", bundle: .main)
        let alertVC = storyboard.instantiateViewController(identifier: "modify") as! Modify
        return alertVC
    }
    
    func cardDetailAlert() -> CardDetailAlert {
        let storyboard = UIStoryboard(name: "CardDetailAlert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(withIdentifier: "CardDetailAlert") as! CardDetailAlert
        return alertVC
    }
}

