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
        var message = ""
        NetworkController.getService.updateUserInfo(name: self.name, email: self.email){ (data) in
            
            if data["status"] as? Int == 200 {
                
                DataManager.instance.setName(name: self.name)
                DataManager.instance.setEmail(email: self.email)
                message = "狀態代碼：\(data["status"] ?? -1)! \n訊息：修改成功"
                DispatchQueue.main.async {
                    self.view.makeToast(message, duration: 1.0, position: .center)
                }
                
            } else if data["status"] as? Int == 500 {
                message = "狀態代碼：\(data["status"] ?? 500)!  訊息： \(data["error"] ?? "未知錯誤")"
                DispatchQueue.main.async {
                    self.view.makeToast(message, duration: 1.0, position: .center)
                }
                print("500: \(message)")
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
