//
//  RegisterViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    let networkController = NetworkController()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle" )
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let rtfAccount: UITextField = {
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
    private let rtfEmail: UITextField = {
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
    
    private let rtfPassword: UITextField = {
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
    private let rtfPasswordConfirm: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "密碼確認"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    private let rtfName: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "姓名"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let rbtnSubmit: UIButton = {
        let button = UIButton()
        button.setTitle("確認註冊", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let btnRegister: UIButton = {
        let button = UIButton()
        button.setTitle("註冊", for: .normal)
        button.backgroundColor = .lightGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
         title = "註冊"
         view.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
        
         rbtnSubmit.addTarget(self,
                               action: #selector(submitButtonTapped),
                               for: .touchUpInside)
         
         rtfAccount.delegate = self
         rtfPassword.delegate = self
         
         // Add subview
         view.addSubview(scrollView)
         scrollView.addSubview(imageView)
         scrollView.addSubview(rtfAccount)
         scrollView.addSubview(rtfEmail)
         scrollView.addSubview(rtfPassword)
         scrollView.addSubview(rtfPasswordConfirm)
         scrollView.addSubview(rtfName)
         scrollView.addSubview(rbtnSubmit)
         
         imageView.isUserInteractionEnabled = true
         scrollView.isUserInteractionEnabled = true
         
         let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
         gesture.numberOfTouchesRequired = 1
         gesture.numberOfTapsRequired = 1
         imageView.addGestureRecognizer(gesture)
        
    }// end of view did load
    
    @objc private func didTapChangeProfilePic(){
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size )
        imageView.layer.cornerRadius = imageView.width/2.0
        rtfAccount.frame = CGRect(x: 30,
                                  y: imageView.bottom + 20,
                                  width: scrollView.width - 60,
                                  height: 52 )
        rtfEmail.frame = CGRect(x: 30,
                                y: rtfAccount.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52 )
        rtfPassword.frame = CGRect(x: 30,
                                   y: rtfEmail.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52 )
        rtfPasswordConfirm.frame = CGRect(x: 30,
                                          y: rtfPassword.bottom + 10,
                                          width: scrollView.width - 60,
                                          height: 52 )
        rtfName.frame = CGRect(x: 30,
                               y: rtfPasswordConfirm.bottom + 10,
                               width: scrollView.width - 60,
                               height: 52 )
        
        rbtnSubmit.frame = CGRect(x: 30,
                                  y: rtfName.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52 )
        
    }
    
    @objc private func submitButtonTapped(){
        rtfAccount.resignFirstResponder()
        rtfEmail.resignFirstResponder()
        rtfPassword.resignFirstResponder()
        rtfPasswordConfirm.resignFirstResponder()
        rtfName.resignFirstResponder()
        
        guard let userAccount = rtfAccount.text,
            let email = rtfEmail.text,
            let password = rtfPassword.text,
            let passwordConfirm = rtfPasswordConfirm.text,
            let userName = rtfName.text,
            !userAccount.isEmpty,
            !email.isEmpty,
            !password.isEmpty, password.count >= 6,
            !passwordConfirm.isEmpty, passwordConfirm.count >= 6,
            !userName.isEmpty else {
                alertUserError(message: "請輸入所有資訊以完成註冊")
                return
        }
        if password != passwordConfirm {
            alertUserError(message: "兩次輸入的密碼不相同，請重新輸入")
            return
        }
        if !isValidateEmail(email){
            alertUserError(message: "輸入的信箱格式不符，請確認" )
            return
        }
        
        // 判斷是否註冊成功
        networkController.register(username: userAccount , email: email , password: password , name: userName){ [weak self]
            (data) in
            guard let strongSelf = self else {
                return
            }
            do {
                let okData = try JSONDecoder().decode(RegisterMsg.self, from: data)
                print("解析成功：\(okData)")
                if okData.status == 200 {
                    print("註冊成功")
                    let message = okData.message
                    print(message!)
                    UserDefaults.standard.set(true, forKey: "Logged_in")
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
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
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "註冊帳號"
        navigationController?.pushViewController(vc, animated: true)
    }


}// end of class
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == rtfAccount {
            rtfPassword.becomeFirstResponder()
        }
        else if textField == rtfPassword {
            submitButtonTapped()
        }
        return true
    }
}

//
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "取消",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "使用相機",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "從相簿選擇",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
