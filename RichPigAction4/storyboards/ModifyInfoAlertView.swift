//
//  ModifyInfoAlertView.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/19.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class ModifyInfoAlertView: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameTxField: UITextField!
    @IBOutlet weak var emailTxField: UITextField!
    
    var account = String()
    var nameText = String()
    var emailText = String()
    
    var buttionAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInfo()
       
    }
    
    func checkInfo(){
        accountLabel.text = DataManager.instance.username
        if nameTxField.text == "" {
            nameTxField.text = DataManager.instance.getName()
        }
        if emailTxField.text == "" {
            emailTxField.text = DataManager.instance.getEmail()
        }
        
    }
    

    @IBAction func didTapConfirm(_ sender: UIButton) {
        dismiss(animated: true)
        DataManager.instance.updateUserInfo {
            
        }
        buttionAction?()
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        
        
        dismiss(animated: true)
        
    }
    


}
