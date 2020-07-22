//
//  ResetNewPasswordVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/22.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class ResetNewPasswordVC: UIViewController {
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
    
    private let tempPassword: UITextField = {
           let field = UITextField()
           field.autocapitalizationType = .none
           field.autocorrectionType = .no
           field.returnKeyType = .done
           field.layer.cornerRadius = 12
           field.layer.borderWidth = 1
           field.layer.borderColor = UIColor.lightGray.cgColor
           field.placeholder = "臨時驗證碼"
           field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
           field.leftViewMode = .always
                   field.isSecureTextEntry = true
           return field
       }()
    
    private let tfPassword: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "新密碼"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
                field.isSecureTextEntry = true
        return field
    }()
    private let tfPasswordConfirm: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "密碼再確認"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
                field.isSecureTextEntry = true
        return field
    }()
    
    private let btnSubmit: UIButton = {
        let button = UIButton()
        button.setTitle("確認", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "重設密碼"
        view.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        btnSubmit.addTarget(self,
                             action: #selector(submitButtonTapped),
                             for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(tfEmail)
        scrollView.addSubview(tempPassword)
        scrollView.addSubview(tfPassword)
        scrollView.addSubview(tfPasswordConfirm)
        scrollView.addSubview(btnSubmit)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        tfEmail.frame = CGRect(x: 30,
                               y: 40,
                               width: scrollView.width - 60,
                               height: 52 )
        tempPassword.frame = CGRect(x: 30,
                                    y: tfEmail.bottom + 10,
                                    width: scrollView.width - 60,
                                    height: 52 )
        tfPassword.frame = CGRect(x: 30,
                                  y: tempPassword.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52 )
        tfPasswordConfirm.frame = CGRect(x: 30,
                                         y: tfPassword.bottom + 10,
                                         width: scrollView.width - 60,
                                         height: 52 )
        btnSubmit.frame = CGRect(x: 30,
                                 y: tfPasswordConfirm.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52 )

    }
    
    @objc private func submitButtonTapped(){

        guard let email = tfEmail.text,
            let temp = tempPassword.text,
            let password = tfPassword.text,
            let rePassword = tfPasswordConfirm.text,
            !email.isEmpty,
            !temp.isEmpty,
            !password.isEmpty, password.count >= 6,
            !rePassword.isEmpty, rePassword.count >= 6
            else {
                alertUserError(message: "請輸入所有資訊")
                return
        }
        if password != rePassword {
            alertUserError(message: "兩次輸入的密碼不相同，請重新輸入")
            return
        }
        if !isValidateEmail(email){
            alertUserError(message: "輸入的信箱格式不符，請確認" )
            return
        }
        
        
        // 判斷是否註冊成功
        NetworkController.getService.resetPassword(email: email, tempt: temp, password: password, rePassword: rePassword, completion: { (data) in
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
                        } else {
                            print("success")
                            DispatchQueue.main.async {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                            
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        
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
