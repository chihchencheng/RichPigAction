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
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var courseHeartLabel: UILabel!
    @IBOutlet weak var courseStarLabel: UILabel!
    var session: URLSession?
    var bookArrTitle = [String]()
    var count = 0
    var index = 0
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
        
//        animationView = .init(name: "books")
//        animationView?.contentMode = .scaleAspectFit
//        animationView?.loopMode = .loop
//        animationView?.animationSpeed = 0.5
//        view.addSubview(animationView!)
//        animationView!.play()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        downloadInfo()
        setupHeartAndStar()
    }// end of view did load
    
    override func viewWillAppear(_ animated: Bool) {
        setupHeartAndStar()
        animationView?.forceDisplayUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func setupHeartAndStar(){
        courseHeartLabel.text = String(DataManager.instance.getHeart())
        courseStarLabel.text = String(DataManager.instance.getStar())
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

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
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
        return cell
    }
}

extension CourseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
