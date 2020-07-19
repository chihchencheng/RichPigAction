//
//  InfoViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class InfoViewController: UIViewController {
    let alertService = AlertService()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appBackground")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0.5
        return imageView
    }()
    
    private var barImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = #colorLiteral(red: 0.9983372092, green: 0.8580152392, blue: 0.8298599124, alpha: 1)
        return imageView
    }()
    
    private var heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "heart")
        return imageView
    }()
    
    private var heartLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 80)
        label.textColor = .systemGreen
        label.text = "5"
        return label
    }()
    
    private var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        //        imageView.image = UIImage(named: "head")
        return imageView
    }()
    
    private var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "star")
        return imageView
    }()
    
    private var starLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 80)
        label.textColor = .systemGreen
        label.text = "5"
        return label
    }()
    
    private var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 35)
        label.textColor = .darkGray
        label.text = "使用者資訊"
        label.textAlignment = .center
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .black
        label.text = "姓名: "
        return label
    }()
    private var nameLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .gray
        label.text = "貝里豬"
        return label
    }()
    
    private var levelLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .black
        label.text = "等級: "
        return label
    }()
    private var levelLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .gray
        label.text = "3"
        return label
    }()
    
    private var accountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .black
        label.text = "帳號: "
        return label
    }()
    private var accountLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .gray
        label.text = "richPig"
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .black
        label.text = "信箱: "
        return label
    }()
    private var emailLabel2: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .gray
        label.text = "pig@gmail.com"
        return label
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemGray4
        button.setTitle("登出", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var modifyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemGray4
        button.setTitle("修改個資", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    var favoriteCourse = ["Love"]//[String]()
    var level = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getHeadImage()
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(nameLabel2)
        scrollView.addSubview(levelLabel)
        scrollView.addSubview(levelLabel2)
        scrollView.addSubview(accountLabel)
        scrollView.addSubview(accountLabel2)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailLabel2)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(modifyButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        scrollView.addSubview(infoView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        scrollView.addSubview(tableView)
        
        scrollView.bringSubviewToFront(logoutButton)
        scrollView.bringSubviewToFront(modifyButton)
        
        logoutButton.addTarget(self,
                              action: #selector(didTapLogout),
                              for: .touchUpInside)
        modifyButton.addTarget(self,
                               action:  #selector(didTapModify),
                               for: .touchUpInside)
        
        nameLabel2.text = DataManager.instance.getName()
        emailLabel2.text = DataManager.instance.getEmail()
        levelLabel2.text = String(DataManager.instance.getLevel())
        accountLabel2.text = DataManager.instance.getUserName()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupInfo()
        getHeadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.frame.size.width
        let height = view.frame.height
        backgroundImageView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: size,
                                           height: height)
        barImageView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: size,
                                    height: 100)
        
        heartImageView.frame = CGRect(x: 15,
                                      y: 25,
                                      width: 70,
                                      height: 70)
        
        heartLabel.frame = CGRect(x: 90,
                                  y: 15,
                                  width: 70,
                                  height: 70)
        
        headImageView.frame = CGRect(x: 150,
                                     y: 25,
                                     width: 70,
                                     height: 70)
        
        starImageView.frame = CGRect(x: 230,
                                     y: 20,
                                     width: 70,
                                     height: 70)
        starLabel.frame = CGRect(x: 305,
                                 y: 15,
                                 width: 70,
                                 height: 70)
        titleLabel.frame = CGRect(x: 0,
                                  y: barImageView.frame.height + 5,
                                  width: view.frame.width - 40,
                                  height: 52)
        
        nameLabel.frame =  CGRect(x: 10,
                                  y: barImageView.frame.height + titleLabel.frame.height + 5,
                                  width: 55,
                                  height: 52)
        nameLabel2.frame =  CGRect(x: 65,
                                   y: barImageView.frame.height + titleLabel.frame.height + 5,
                                   width: 150,
                                   height: 52)
        
        levelLabel.frame =  CGRect(x: 10,
                                   y: 190,
                                   width: 55,
                                   height: 52)
        levelLabel2.frame =  CGRect(x: 65,
                                    y: 190,
                                    width: 150,
                                    height: 52)
        accountLabel.frame =  CGRect(x: 10,
                                     y: 225,
                                     width: 55,
                                     height: 52)
        accountLabel2.frame =  CGRect(x: 65,
                                      y: 225,
                                      width: 150,
                                      height: 52)
        emailLabel.frame =  CGRect(x: 10,
                                   y: 260,
                                   width: 55,
                                   height: 52)
        emailLabel2.frame =  CGRect(x: 65,
                                    y: 260,
                                    width: 200,
                                    height: 52)
        
        modifyButton.frame = CGRect(x: 65,
                                    y: 320,
                                    width: 100,
                                    height: 52)
        
        logoutButton.frame = CGRect(x: 200,
                                    y: 320,
                                    width: 100,
                                    height: 52)
        
        
        
        infoView.frame = CGRect(x: 0,
                                y: barImageView.frame.height + 5,
                                width: view.frame.size.width,
                                height: (view.frame.size.height - barImageView.frame.height)/2)
        tableView.frame = CGRect(x: 0,
                                 y: infoView.frame.maxY + 5,
                                 width: view.frame.size.width,
                                 height: (view.frame.size.height - barImageView.frame.height)/2)
           
    }
    
    private func getHeadImage(){
        DataManager.instance.getUserImage { (image) in
            DispatchQueue.main.async {
                self.headImageView.image = image
            }
        }
    }
    
    private func setupInfo(){
        self.starLabel.text = String(DataManager.instance.getStar())
        self.heartLabel.text = String(DataManager.instance.getHeart())
        self.level = DataManager.instance.getLevel()
    }

    @objc func didTapLogout(_ sender: UIButton) {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
        
    }
    
    @objc func didTapModify(_ sender: UIButton) {
      let vc = (self.storyboard?.instantiateViewController(identifier: "modifyVC"))! as ModifyVC
        self.present(vc, animated: true)
    }
    
}// end of class

extension InfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 52)
        myLabel.font = UIFont.boldSystemFont(ofSize: 30)
        myLabel.text = "我的最愛課程"
        myLabel.textAlignment = .center
        myLabel.textColor = .brown
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 8, width: 320, height: 52)
        label.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.text = favoriteCourse[indexPath.row]
        cell.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
}

extension InfoViewController: UITableViewDelegate {
    
}
