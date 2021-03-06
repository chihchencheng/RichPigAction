//
//  LoginViewViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    let alertService = AlertService()
    
    
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
    
    private let forgotPassword: UIButton = {
        let button = UIButton()
        button.setTitle("忘記密碼？", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.backgroundColor = .none
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "登入"
        view.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "註冊",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        btnLogin.addTarget(self,
                           action: #selector(loginButtonTapped),
                           for: .touchUpInside)
        forgotPassword.addTarget(self,
                           action: #selector(didTapforgot),
                           for: .touchUpInside)
        
        tfAccount.delegate = self
        tfPassword.delegate = self
        
        // Add subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(tfAccount)
        scrollView.addSubview(tfPassword)
        scrollView.addSubview(btnLogin)
        scrollView.addSubview(forgotPassword)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
       self.view.addGestureRecognizer(tap)
    }// end of view did load
    
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
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
        forgotPassword.frame = CGRect(x: scrollView.width - 230,
                                      y: btnLogin.bottom + 5,
                                      width: scrollView.width - 60,
                                      height: 32 )
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
        NetworkController.getService.login(username: userName, password: password) {[weak self] (data) in
            guard let strongSelf = self else {
                return
            }
            
            
            do {
//                let alertVC = (self?.alertService.loginAlert())! as LoginAlertViewController
               
                let okData = try JSONDecoder().decode(LoginInfo.self, from: data)
                print("解析成功：\(okData)")
                
                if okData.status == 200 {
                    
                    print("登入成功")
                    let message = okData.message
                    let token = "\(message?.tokenType ?? "Bearer") \(message?.accessToken ?? "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJyaWNoUGlnIiwiaWF0IjoxNTk0NjkwMzMxLCJleHAiOjE1OTk4NzQzMzF9.iu9EfBoFtMv_M64vlOeL4pIHg_0SAZ_X9NHw9WS9xtL0LD8OzUGYrqGZtbB0Z15G3fSm4yuawS6gq0ajH7r7FQ")"
                    let heart = message?.loveTime
                    let star = message?.star
                    let level = message?.level
                    
                    UserDefaults.standard.set(token, forKey: "Token")
                    UserDefaults.standard.set(true, forKey: "Logged_in")
                    DataManager.instance.setToken(token: token)
                    print("新登入得到的新token\(DataManager.instance.getToken())")
                    DataManager.instance.setHeart(heart: heart!)
                    DataManager.instance.setStar(star: star!)
                    DataManager.instance.setLevel(level: level!)
                    DataManager.instance.setUserName(username: userName)
                    let group = DispatchGroup()
                    group.enter()
                    DispatchQueue.main.async {
//                        let vc = LevelViewController()
//                        let tab = UITabBarController()
//                        vc.modalPresentationStyle = .fullScreen
//                        strongSelf.present(vc, animated: true)
//                        strongSelf.navigationController?.dismiss(animated: true)
                        //===== 重新登入回到預設畫面
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainTabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        group.leave()
                    }
                    group.notify(queue: .main){
                        
                        strongSelf.navigationController?.dismiss(animated: false){
                            
//                            tab.selectedIndex == 1
                        }
//                        self!.present(mainTabBarController, animated: true)
                        
//
//                        // This is to get the SceneDelegate object from your view controller
//                        // then call the change root view controller function to change to main tab bar
//                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                        //=====
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

    @objc private func didTapforgot(){
           let vc = ResetPasswordVC()
           vc.title = "重設密碼"
           navigationController?.pushViewController(vc, animated: true)
       }

}// end of class


extension LoginViewController: UITextFieldDelegate {
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
