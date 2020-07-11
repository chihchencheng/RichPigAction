//
//  InfoViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
           let scrollView = UIScrollView()
           scrollView.backgroundColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
           scrollView.clipsToBounds = true
           return scrollView
       }()
       
       private let pbtnLogout: UIButton = {
           let button = UIButton()
           button.setTitle("登出", for: .normal)
           button.backgroundColor = #colorLiteral(red: 0.9251550436, green: 0.6507889628, blue: 0.9241239429, alpha: 1)
           button.setTitleColor(.red, for: .normal)
           button.layer.cornerRadius = 12
           button.layer.masksToBounds = true
           button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
           return button
       }()

    override func viewDidLoad() {
        super.viewDidLoad()

        pbtnLogout.addTarget(self,
                             action: #selector(logoutButtonTapped),
                             for: .touchUpInside)
        view.addSubview(scrollView)
        scrollView.addSubview(pbtnLogout)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
       }
       
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           scrollView.frame = view.bounds
           pbtnLogout.frame = CGRect(x: 30,
                                     y: 100,
                                     width: scrollView.width - 60,
                                     height: 52 )
       }
       
      
       
       @IBAction func logoutButtonTapped(_ sender: UIButton) {
           let defaults = UserDefaults.standard
           let vc = LoginViewViewController()
           let nav = UINavigationController(rootViewController: vc)
           nav.navigationBar.barTintColor = #colorLiteral(red: 0.9983767867, green: 0.8579687476, blue: 0.8342047334, alpha: 1)
           nav.modalPresentationStyle = .fullScreen
           present(nav, animated: false)
           defaults.set(false, forKey: "logged_in")
           
       }


}
