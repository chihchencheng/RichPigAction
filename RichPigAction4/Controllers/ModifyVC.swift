//
//  ModifyVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/19.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Toast_Swift

class ModifyVC: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailFied: UITextField!
    
    var account = DataManager.instance.getUserName()
    var name = DataManager.instance.getName()
    var email = DataManager.instance.getEmail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountLabel.text = account
        nameField.text = name
        emailFied.text = email
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountLabel.text = account
        nameField.text = name
        emailFied.text = email
    }

    @IBAction func didTapConfirm(_ sender: UIButton) {
        if nameField.text == "" || emailFied.text == "" {
            return
        }
        name = nameField.text ?? self.name
        email = emailFied.text ?? self.email
        NetworkController.getService.updateUserInfo(name: name, email: email){data in
            print(data)
            DispatchQueue.main.async {
                 self.view.makeToast("資料更新成功！", duration: 2.0, position: .center)
            }
            DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
