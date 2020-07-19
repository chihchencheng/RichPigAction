//
//  LevelViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
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
    
    
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var lbHeartAmount: UILabel!
//    @IBOutlet weak var lbStarAmount: UILabel!
//    @IBOutlet weak var headImageView: UIImageView!
    let alertService = AlertService()
    
    var star = DataManager.instance.getStar()
    var heart = DataManager.instance.getHeart()
    var level = DataManager.instance.getLevel()
//    var session: URLSession?
    var noseArr = [String]()
    var singleArr = [SingleData]()
    var quizArr = [Quiz]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        session = URLSession(configuration: .default)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(NoseCollectionViewCell.nib(), forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        //判斷手機內是否有有效的token
        if UserDefaults.standard.object(forKey: "Token") == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
            UserDefaults.standard.set(false, forKey: "logged_in")

        }else {// 有token，向server請求資料
            DataManager.instance.updateUserInfo {
                self.setupInfo()
                self.getHeadImage()
            }
            downloadCourseInfo()
            
        }
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        view.bringSubviewToFront(collectionView)
        guard let currentTime = Date().toMillis() else { return }
        DataManager.instance.setupLoginTime(time: currentTime)
    }// end of view did load
    
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
    }
    
    
    private func getHeadImage(){
        DataManager.instance.getUserImage { (image) in
            DispatchQueue.main.async {
                self.headImageView.image = image
                DataManager.instance.setHeadImage(image: image)
            }
            
        }
    }

    
    
    private func setupInfo(){
        DispatchQueue.main.async {
            self.star = DataManager.instance.getStar()
            self.heart = DataManager.instance.getHeart()
            self.level = DataManager.instance.getLevel()
            print(self.level)
            self.starLabel.text = String(self.star)
            self.heartLabel.text = String(self.heart)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInfo()
        downloadCourseInfo()
        getHeadImage()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        DataManager.instance.gainHeart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    
    func downloadCourseInfo(){
        let url = MyUrl.tutorials.rawValue
        NetworkController.getService.useTokenToGet(url: url) { (data) in
            do {
                let okData = try JSONDecoder().decode(AllData.self, from: data)
                self.noseArr = self.updateLevelLabel(okData)
                self.getAllQuizArray(okData)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                DispatchQueue.main.async {
                    let vc = LoginViewController()
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: false)
                    UserDefaults.standard.set(false, forKey: "logged_in")
//                    self.popAler(withMessage: "Sorry")
                }
            }
        }
    }// end of download info

    
    //取得quize的陣列
    func getAllQuizArray(_ okData: AllData){
        if let okSingle = okData.message {
            self.singleArr = okSingle
        }
    }
    
    
    //取得關卡總數
    func getTotalLevelAmount(_ okData: AllData) {
        if let okCount = okData.message?.count {
            self.level = okCount
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    // 更新關卡的標籤
    func updateLevelLabel(_ okData: AllData) -> [String]{
        var noseArr = [String]()
        guard let count = okData.message?.count else {return ["0"]}
        
        for item in 0...count-1 {
            if let id = okData.message?[item].id {
                noseArr.append("\(id+1)")
            }
        }
        return noseArr
    }
    
    
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}// end of class

extension LevelViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if self.singleArr[indexPath.row].type == 0 || self.singleArr[indexPath.row].type == 1 {
//        let title = "Level: \(self.singleArr[indexPath.row].id ?? 0)"
        let body = self.singleArr[indexPath.row].title ?? "Data Error"
        if indexPath.row > self.level {
            return
        }
        if DataManager.instance.getHeart() <= 0 {
            popAler(withMessage: "愛心數不足！")
            return
        }
        let alertVC = alertService.alert(title: "富豬行動" , body: body, buttonTitle: "開始") {
            let vc = (self.storyboard?.instantiateViewController(identifier: "QuizViewController"))! as QuizViewController
            DispatchQueue.main.async {
                self.heart -= 1
                DataManager.instance.setHeart(heart: self.heart)
                print("選擇關卡，進入下一個畫面之前的\(DataManager.instance.getHeart())")
                self.heartLabel.text = (String)(self.heart)
            }
            UserDefaults.standard.set(indexPath.row, forKey: "gameLevel")
            self.present(vc, animated: true)
        }
        
            self.present(alertVC, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "quiz" {
//            let dvc = segue.destination as? QuizViewController
//            dvc?.level = self.level
//        }
//    }
}



extension LevelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return noseArr.count //level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as! NoseCollectionViewCell
        if indexPath.row > self.level {
            cell.configure(with: UIImage(named: "nose1")!, level: noseArr[indexPath.row])// level[indexPath.row]
        } else {
            cell.configure(with: UIImage(named: "nose3")!, level: noseArr[indexPath.row])// level[indexPath.row]
            
        }
        return cell
    }
}

extension LevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

