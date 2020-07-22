//
//  ResetPasswordVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/21.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let tfEmail: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "信箱"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let ebtnSubmit: UIButton = {
        let button = UIButton()
        button.setTitle("確認送出", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘記密碼"
        view.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        ebtnSubmit.addTarget(self,
                             action: #selector(didTapSendEmail),
                             for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(tfEmail)
        scrollView.addSubview(ebtnSubmit)
        
        tfEmail.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyBoard(){
           self.view.endEditing(true)
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        tfEmail.frame = CGRect(x: 30,
                               y: 40,
                               width: scrollView.width - 60,
                               height: 52 )
        
        ebtnSubmit.frame = CGRect(x: 30,
                                 y:tfEmail.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52 )
    }
    
    @objc private func didTapSendEmail(){
        guard let email = tfEmail.text,!email.isEmpty
            else {
                DispatchQueue.main.async {
                    self.alertUserError(message: "請輸入所有資訊以完成註冊")
                }
                return
        }
        if !isValidateEmail(email){
            alertUserError(message: "輸入的信箱格式不符，請確認" )
            return
        }
        
        NetworkController.getService.forgotPassword(email: email) { (data) in
            do {
                let okData = try JSONSerialization.jsonObject(with: data)
                if let okJson = okData as? [String: Any] {
                    if let status = okJson["status"] as? Int {
                        if status != 200 {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Message", message: "未知錯誤，請稍後再試", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            }
                            return
                        } else if(status == 400){
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Message", message: "查無此信箱", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            }
                            return
                        }
                        
                        else {
                            print("success")
                            DispatchQueue.main.async {
                                let vc = ResetNewPasswordVC()
                                vc.title = "重設密碼"
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }//
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // validate email format
    func isValidateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    
    
    func alertUserError(message: String){
        let alert = UIAlertController(title: "Message",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }


}

extension ResetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
