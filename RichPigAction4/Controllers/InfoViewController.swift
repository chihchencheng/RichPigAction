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
    var courseArr = [String]()
    
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
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private var tableViewLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 30)
        label.textColor = .darkGray
        label.text = "我的最愛"
        label.textAlignment = .center
        return label
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
        tableView.backgroundColor = .none
        tableView.separatorStyle = .none
        scrollView.addSubview(tableView)
        scrollView.addSubview(tableViewLabel)
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
        
        tableView.isUserInteractionEnabled = true
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
//        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupInfo()
        nameLabel2.text = DataManager.instance.getName()
        emailLabel2.text = DataManager.instance.getEmail()
        levelLabel2.text = String(DataManager.instance.getLevel())
        accountLabel2.text = DataManager.instance.getUserName()
        getHeadImage()
        
        getFavorite()
       
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
        
        starImageView.frame = CGRect(x: 220,
                                     y: 20,
                                     width: 70,
                                     height: 70)
        starLabel.frame = CGRect(x: 295,
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
        
        tableViewLabel.frame = CGRect(x: view.frame.width/2-50,
                                      y:360,
                                      width: 100,
                                      height: 52)
        
        
        
        infoView.frame = CGRect(x: 0,
                                y: barImageView.frame.height + 5,
                                width: view.frame.size.width,
                                height: (view.frame.size.height - barImageView.frame.height)/2)
        tableView.frame = CGRect(x: 0,
                                 y: infoView.frame.maxY + 15,
                                 width: view.frame.size.width,
                                 height: (view.frame.size.height - barImageView.frame.height)/2)
           
    }
    
    private func getHeadImage(){
        self.headImageView.image = DataManager.instance.getHeadImage()
    }
    
    private func setupInfo(){
        self.starLabel.text = String(DataManager.instance.getStar())
        self.heartLabel.text = String(DataManager.instance.getHeart())
        self.level = DataManager.instance.getLevel()
    }

    private func getFavorite(){ //會有重複列表的問題
        NetworkController.getService.getFavorite { (data) in
            do {
                let decodedData = try JSONDecoder().decode(AllFavorite.self, from: data)
                if let allFavorite = decodedData.message {
                    self.courseArr.removeAll()
                    for item in 0...allFavorite.favorite!.count-1{
                        
                        self.courseArr.append("\(allFavorite.favorite![item][0].level ?? -1):" + allFavorite.favorite![item][0].desc!)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    @objc func didTapLogout(_ sender: UIButton) {
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set(false, forKey: "Logged_in")
        UserDefaults.standard.set(nil, forKey: "Token")
        self.present(nav, animated: true)
        
    }
    
    @objc func didTapModify(_ sender: UIButton) {
      let vc = (self.storyboard?.instantiateViewController(identifier: "modifyVC"))! as ModifyVC
        self.present(vc, animated: true)
    }
    
}// end of class

extension InfoViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 8, width: 320, height: 52)
        label.font = UIFont.systemFont(ofSize: 28)
        cell.textLabel?.text = "❤️\(courseArr[indexPath.row])"
        cell.backgroundColor = #colorLiteral(red: 0.552705586, green: 0.8715922236, blue: 1, alpha: 0.8470588235)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        cell.layer.cornerRadius = 12
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 1, green: 0.7390170097, blue: 0.7540183663, alpha: 1)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
}

extension InfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: "Message", message: "從我的最愛移除？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let removeHandler = UIAlertAction(title: "刪除", style: .default) { (handler) in
            let index = self.courseArr[indexPath.row].split(separator: ":")[0]
            self.courseArr.remove(at: indexPath.row)
           DispatchQueue.main.async {
               tableView.reloadData()
           }
           NetworkController.getService.removeFavorite(index: String(index)) { (data) in
               
           }
           
        }
        optionMenu.addAction(removeHandler)
        present(optionMenu, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = courseArr[indexPath.row].split(separator: ":")[0]
            courseArr.remove(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            NetworkController.getService.removeFavorite(index: String(index)) { (data) in
                
            }
        }
    }
}
