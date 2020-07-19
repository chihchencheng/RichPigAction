//
//  CourseViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class CourseViewController: UIViewController {
    
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
//    @IBOutlet weak var courseHeartLabel: UILabel!
//    @IBOutlet weak var courseStarLabel: UILabel!
//    @IBOutlet weak var headImageView: UIImageView!
    
    var session: URLSession?
    var bookArrTitle = [String]()
    var count = 0
    var index = 0
    var level = 0
    var courseArr = [Course]()
    var allCourseArr = [[Course]]()
    private var animationView: AnimationView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120,
                                 height: 120)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(BookCollectionViewCell.nib(), forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        downloadInfo()
        DataManager.instance.updateUserInfo {self.setupInfo()}
        getHeadImage()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        view.bringSubviewToFront(collectionView)
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
            }
        }
    }
    
    private func setupInfo(){
        self.starLabel.text = String(DataManager.instance.getStar())
        self.heartLabel.text = String(DataManager.instance.getHeart())
        self.level = DataManager.instance.getLevel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupInfo()
        getHeadImage()
        //        animationView?.forceDisplayUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    func downloadInfo(){
        let url = MyUrl.tutorials.rawValue
        NetworkController.getService.useTokenToGet(url: url) { (data) in
            do {
                let okData = try JSONDecoder().decode(AllData.self, from: data)
                self.getCourseArr(okData)
                self.getAllcourse(okData)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.popAler(withMessage: "Sorry")
                }
            }
        }
    }// end of download info

    //課程總數
    func getAllCourseAmount(_ okData: AllData) {
        if let countOk = okData.message?.count {
            self.count = countOk
        }else {return}
        print("課程總數: \(count)")
    }
    
    //課程的標題陣列
    func getCourseArr(_ okData: AllData) {
        getAllCourseAmount(okData)
        for item in 0...self.count-1 {
            if let okTitle = okData.message?[item].title {
                self.bookArrTitle.append(okTitle)
            } else {
                print("課程array解析失敗")
            }
        }
    }
    
    //全部課程的陣列
    func getAllcourse(_ okData: AllData){
        for item in 0...self.count-1 {
            if let okCourse = okData.message?[item].courses {
                self.allCourseArr.append(okCourse)
            } else {
                print("無法取得課程陣列的陣列")
                return
            }
        }
        
    }
    
    //取出特定課程的陣列
    func getCoursesArrByIndex(index: Int) -> [Course]{
        return self.allCourseArr[index]
    }
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}// end of class

extension CourseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath.row
        performSegue(withIdentifier: "courseDetail", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "courseDetail" {
            let dvc = segue.destination as? CourseDetailVC
            dvc?.index = self.index
            dvc?.allCourseArr = self.allCourseArr
        }
    }
}

extension CourseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  bookArrTitle.count//level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        cell.setTitle(course: bookArrTitle[indexPath.row])
        cell.rePlay()
        return cell
    }
}

extension CourseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
