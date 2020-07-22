//
//  CourseDetailVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import iCarousel
import Toast_Swift

class CourseDetailVC: UIViewController {
    
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
    private var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("退出", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = #colorLiteral(red: 0.3156232238, green: 0.4780945182, blue: 0.7871525288, alpha: 1)
        return button
    }()
    
    private var shareButton = UIButton()
    private var addFavoriteButton = UIButton()
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        return view
    }()
    
    private var indexLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = .blue
        label.text = "-1"
        return label
    }()

    var session: URLSession?
    var courseArr = [Course]()
    var allCourseArr = [[Course]]()
    var imgArr = [UIImage]()
    var titleArr = [String]()
    var index = DataManager.instance.getCourseIndex()
    var level = 0
    var favoriteCourse = [Course]()
    
    var myScrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        
        scrollView.addSubview(myCarousel)
        scrollView.addSubview(closeButton)
        myCarousel.dataSource = self
        //        myCarousel.autoscroll = -0.3
        
        session = URLSession(configuration: .default)
        getImageDownload()
        setupInfo()
        
        closeButton.addTarget(self,
                              action: #selector(didTapClose),
                              for: .touchUpInside)
        shareButton.addTarget(self,
                              action: #selector(didTapShare),
                              for: .touchUpInside)
 
    }// end of view did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        myCarousel.reloadData()
        
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
        myCarousel.frame = CGRect(x: 0,
                                  y: 120,
                                  width: view.frame.size.width,
                                  height: 400)
        
        indexLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: 100,
                                  height: 52)
        
        closeButton.frame = CGRect(x: scrollView.frame.minX + 10,
                                   y: scrollView.frame.maxY - 80,
                                   width: scrollView.frame.width - 32,
                                   height: 52)
        
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
        DataManager.instance.getUserImage { (image) in
            DispatchQueue.main.async {
                self.headImageView.image = image
            }
        }
       }
    
    private func getImageDownload(){
        self.index = DataManager.instance.getCourseIndex()
        self.courseArr = allCourseArr[self.index]
        for item in 0...courseArr.count-1  { //stride(from:courseArr.count-1, to: 0, by:-1)
            if let url = URL(string: courseArr[item].url ?? "http://104.199.188.255:8080/files/200706072649+0000ch00.JPG"){

                let task = session?.downloadTask(with: url, completionHandler: {
                    (url, respons, error) in
                    if error != nil {
                        let errorCode = (error! as NSError).code
                        if errorCode == -1009 {
                            print("no internet connection")
                        }else {
                            print(error!.localizedDescription)
                        }
                        return
                    }
                    if let loadedURL = url {
                        do {
                            self.titleArr.append(self.courseArr[item].desc ?? "沒有值")
                            if let loadedImage = UIImage(data: try Data(contentsOf: loadedURL)){
                                self.imgArr.append(loadedImage)
//
                            }
                            DispatchQueue.main.async {
                                self.myCarousel.reloadData()
                            }
                        } catch{
                            print(error.localizedDescription)
                        }
                    }
                })
                task?.resume()
            }
        }
    }
    

 
  
    
    @objc func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapShare(_ sender: UIButton){
        let activityController = UIActivityViewController(activityItems: [self.imgArr[0], self.courseArr[0].desc as Any],applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func didTapAdd(_ sender: UIButton) {
        if DataManager.instance.getFavoriteCourses().count != 0 {
            for item in 0...DataManager.instance.getFavoriteCourses().count - 1{
                
                if self.index == DataManager.instance.getFavoriteCourses()[item]{
                    self.view.makeToast("已經加過我的最愛囉", duration: 1.0, position: .bottom)
                    return
                }
            }
        }
        
        NetworkController.getService.addFavorite(courseIndex: self.index){ data in
            let status = data["status"] as? Int ?? -1
            if status == 200 {
                DispatchQueue.main.async {
                    self.view.makeToast("加入我的最愛成功❣️", duration: 2.0, position: .center)
                }
                
                DataManager.instance.addFavoriteCourse(courseIndex: self.index)
            } else if status == 400 {
                DispatchQueue.main.async {
                    self.view.makeToast("已經加過囉💕", duration: 1.0, position: .center)
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.view.makeToast("不知名的錯誤💔", duration: 1.0, position: .center)
                }
                return
            }
           
        }
    }
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}// end of class

extension CourseDetailVC: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        imgArr.count
    }
    //設定圖表大小以及位置
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width - 10, height: 380))
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: view.width - 10, height: 350))//frame: view.bounds
        view.addSubview(imageView)
        indexLabel = UILabel(frame: CGRect(x: 10, y: view.height-50, width: 200, height: 50))
        shareButton = UIButton(frame: CGRect(x: 200, y: view.height-42, width: 50, height: 40))
        shareButton.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.setTitle("分享", for: .normal)
        shareButton.layer.cornerRadius = 12
        addFavoriteButton = UIButton(frame: CGRect(x: 260, y: view.height-42, width: 100, height: 40))
        addFavoriteButton.backgroundColor = #colorLiteral(red: 1, green: 0.6316934228, blue: 0.8795467019, alpha: 1)
        addFavoriteButton.setTitleColor(.white, for: .normal)
        addFavoriteButton.setTitle("❤️我的最愛", for: .normal)
        addFavoriteButton.layer.cornerRadius = 12
        addFavoriteButton.addTarget(self,
                                    action: #selector(didTapAdd),
                                    for: .touchUpInside)
        shareButton.addTarget(self,
                              action: #selector(didTapShare),
                              for: .touchUpInside)
        imageView.contentMode = .scaleAspectFit
        
        if !imgArr.isEmpty {
            let img = imgArr[index]
            let text = "\(titleArr[index])-\(index)"
            indexLabel.text = text
            imageView.image = img
            view.addSubview(imageView)
            view.addSubview(indexLabel)
            view.addSubview(shareButton)
            view.addSubview(addFavoriteButton)
            view.bringSubviewToFront(addFavoriteButton)
        }
        return view
    }
    
}

extension CourseDetailVC: iCarouselDelegate {
    
}
