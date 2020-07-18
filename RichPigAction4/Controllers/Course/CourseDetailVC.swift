//
//  CourseDetailVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import iCarousel

class CourseDetailVC: UIViewController, iCarouselDataSource, UIScrollViewDelegate {
    
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

//    @IBOutlet weak var heartLabel: UILabel!
//    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    var session: URLSession?
    var courseArr = [Course]()
    var allCourseArr = [[Course]]()
    var imgArr = [UIImage]()
    var index = 0
    var level = 0
    
    var myScrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        myScrollView = UIScrollView()
//        myScrollView.frame = CGRect(x: 0, y: 20,
//                                    width: view.frame.size.width ,
//                                    height:view.frame.size.height - 20)
//        myScrollView.contentSize = CGSize(width: view.frame.size.width * 5,
//                                          height: view.frame.size.height - 20)
//
//        myScrollView.showsHorizontalScrollIndicator = false
//        myScrollView.showsVerticalScrollIndicator = false
        // 滑動超過範圍時是否使用彈回效果
//        myScrollView.bounces = true

        // 設置委任對象
//        myScrollView.delegate = self

        // 以一頁為單位滑動
//        myScrollView.isPagingEnabled = true

        // 加入到畫面中
//        self.view.addSubview(myScrollView)
        // 建立 UIPageControl 設置位置及尺寸
//        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0,
//                                                  width: myScrollView.frame.width * 0.85,
//                                                  height: 50))
//        pageControl.center = CGPoint(x: myScrollView.frame.width * 0.5,
//                                     y: myScrollView.frame.height * 0.85)

        // 有幾頁 就是有幾個點點
//        pageControl.numberOfPages = imgArr.count//5

        // 起始預設的頁數
//        pageControl.currentPage = 0

        // 目前所在頁數的點點顏色
//        pageControl.currentPageIndicatorTintColor =
//          UIColor.black

        // 其餘頁數的點點顏色
//        pageControl.pageIndicatorTintColor = UIColor.lightGray

        // 增加一個值改變時的事件
//        pageControl.addTarget(
//          self,
//          action: #selector(CourseDetailVC.pageChanged),
//          for: .valueChanged)

        // 加入到基底的視圖中 (不是加到 UIScrollView 裡)
        // 因為比較後面加入 所以會蓋在 UIScrollView 上面
//        self.view.addSubview(pageControl)
        // 建立 5 個 UILabel 來顯示每個頁面內容
//        var myLabel = UILabel()
//        for i in 0...4 {
//            myLabel = UILabel(frame: CGRect(x: 0, y: 0,
//                                            width: view.frame.width,
//                                            height: 40))
//            myLabel.center = CGPoint(x: view.frame.width * (0.5 + CGFloat(i)),
//                                     y: view.frame.height * 0.2)
//            myLabel.font = UIFont(name: "Helvetica-Light", size: 48.0)
//            myLabel.textAlignment = .center
//            myLabel.text = "\(i + 1)"
//            myScrollView.addSubview(myLabel)
//        }
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        
        scrollView.addSubview(myCarousel)
        myCarousel.dataSource = self
        //        myCarousel.autoscroll = -0.3
        
        session = URLSession(configuration: .default)
        getImageDownload()
        setupInfo()
        scrollView.addSubview(closeButton)
        closeButton.addTarget(self,
                              action: #selector(didTapClose),
                              for: .touchUpInside)
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
        myCarousel.frame = CGRect(x: 0,
                                  y: 120,
                                  width: view.frame.size.width,
                                  height: 400)
        
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
    
    // 滑動結束時
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 左右滑動到新頁時 更新 UIPageControl 顯示的頁數
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    
    // 點擊點點換頁
    @objc func pageChanged(_ sender: UIPageControl) {
        // 依照目前圓點在的頁數算出位置
        var frame = myScrollView.frame
        frame.origin.x =
            frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0
        
        // 再將 UIScrollView 滑動到該點
        myScrollView.scrollRectToVisible(frame, animated:true)
    }
    
    func setupPageController(){
        
    }

    
    private func getImageDownload(){
        self.courseArr = allCourseArr[self.index]
        for item in 0...courseArr.count-1 {
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
                            if let loadedImage = UIImage(data: try Data(contentsOf: loadedURL)){
                                self.imgArr.append(loadedImage)
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
    

 
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        imgArr.count
    }
    
    @objc func didTapClose(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "course") as! CourseViewController
        dismiss(animated: true, completion: nil)
    }
    
    //設定圖表大小以及位置
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width - 10, height: 380))
        view.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: 5, y: 0, width: view.width - 10, height: 350))//frame: view.bounds
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        if !imgArr.isEmpty {
            let img = imgArr[index]
            imageView.image = img
            view.addSubview(imageView)
        }
        return view
    }

    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}// end of class
