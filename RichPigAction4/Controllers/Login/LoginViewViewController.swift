//
//  LoginViewViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class LoginViewViewController: UIViewController {
    
    let networkController = NetworkController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginBackground")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tfAccount: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "帳號"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
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
        field.placeholder = "密碼"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let btnLogin: UIButton = {
        let button = UIButton()
        button.setTitle("登入", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登入"
        view.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "註冊",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        btnLogin.addTarget(self,
                           action: #selector(loginButtonTapped),
                           for: .touchUpInside)
        
        tfAccount.delegate = self
        tfPassword.delegate = self
        
        // Add subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(tfAccount)
        scrollView.addSubview(tfPassword)
        scrollView.addSubview(btnLogin)

       
    }// end of view did load
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width
        imageView.frame = CGRect(x: 0,
                                 y: 80,
                                 width: size,
                                 height: 240 )
        
        tfAccount.frame = CGRect(x: 30,
                                 y: imageView.bottom + 20,
                                 width: scrollView.width - 60,
                                 height: 52 )
        tfPassword.frame = CGRect(x: 30,
                                  y: tfAccount.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52 )
        btnLogin.frame = CGRect(x: 30,
                                y: tfPassword.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52 )
    }
    
    @objc private func loginButtonTapped(){
        tfAccount.resignFirstResponder()
        tfPassword.resignFirstResponder()
        guard let userName = tfAccount.text, let password = tfPassword.text,
            !userName.isEmpty, !password.isEmpty, password.count >= 6 else {
                alertUserError(message: "請輸入帳號及密碼登錄")
                return
        }
        //連網判斷帳密是否正確
        networkController.login(username: userName, password: password) {[weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            do {
                let okData = try JSONDecoder().decode(LoginInfo.self, from: data)
                print("解析成功：\(okData)")
                
                if okData.status == 200 {
                    print("登入成功")
                    let message = okData.message
                    let token = message?.accessToken
                    UserDefaults.standard.set(token, forKey: "Token")
                    UserDefaults.standard.set(true, forKey: "Logged_in")
                    DispatchQueue.main.async {
                        strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                    }
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func alertUserError(message: String){
        let alert = UIAlertController(title: "Message",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "註冊帳號"
        navigationController?.pushViewController(vc, animated: true)
    }


}// end of class


extension LoginViewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfAccount {
            tfPassword.becomeFirstResponder()
        }
        else if textField == tfPassword {
            loginButtonTapped()
        }
        return true
    }
}
