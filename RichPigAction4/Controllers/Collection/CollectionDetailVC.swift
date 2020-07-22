//
//  CollectionDetailVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CollectionDetailVC: UIViewController {
    var piggy = Piggy()
    var image = UIImage()
    var session: URLSession?
    
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
    
    private var detailView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9983372092, green: 0.8580152392, blue: 0.8298599124, alpha: 1)
        view.alpha = 0.8
        view.layer.borderWidth = 6
        view.layer.borderColor = #colorLiteral(red: 0.6050576568, green: 0.3571550548, blue: 0.106277667, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "head")
        imageView.alpha = 1
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = ""
        return label
    }()
    
    private var describeLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 20)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = ""
        label.layer.cornerRadius = 12
        label.layer.borderWidth = 4
        label.layer.borderColor = #colorLiteral(red: 0.9251550436, green: 0.6507889628, blue: 0.9241239429, alpha: 1)
        return label
    }()
    
    private var characView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 4
        view.layer.borderColor = #colorLiteral(red: 0.9251550436, green: 0.6507889628, blue: 0.9241239429, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var characLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "特質"
        return label
    }()
    
    private var characDescLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 12)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = ""
        return label
    }()
    
    private var statusView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 4
        view.layer.borderColor = #colorLiteral(red: 0.9251550436, green: 0.6507889628, blue: 0.9241239429, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "狀態"
        return label
    }()
    
    private var statusDescLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Georgia-BoldItalic", size: 12)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = ""
        return label
    }()
    
    private var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        //        button.setImage(UIImage(named: "Icon-Facebook-72"), for: .normal)
        button.setTitle("分享", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = #colorLiteral(red: 0.1545820832, green: 0.3832257092, blue: 1, alpha: 1)
        return button
    }()
    private var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "xmark.circle")
        button.setImage(image, for: .normal)
        button.setTitleColor(.brown, for: .normal)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        getImageDownload()
        getHeadImage()
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        
        scrollView.addSubview(detailView)
        
        detailView.addSubview(detailImageView)
        detailView.addSubview(nameLabel)
        detailView.addSubview(describeLabel)
        detailView.addSubview(characView)
        characView.addSubview(characLabel)
        characView.addSubview(characDescLabel)
        detailView.addSubview(statusView)
        statusView.addSubview(statusLabel)
        statusView.addSubview(statusDescLabel)
        detailView.addSubview(shareButton)
        detailView.addSubview(closeButton)
        closeButton.addTarget(self,
                              action: #selector(didTapCross),
                              for: .touchUpInside)
        shareButton.addTarget(self,
                              action: #selector(didTapShare),
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
        
        starImageView.frame = CGRect(x: 220,
                                     y: 20,
                                     width: 70,
                                     height: 70)
        starLabel.frame = CGRect(x: 295,
                                 y: 15,
                                 width: 70,
                                 height: 70)
        
        detailView.frame = CGRect(x: 15,
                                  y: 130,
                                  width: view.frame.size.width - 30,
                                  height: view.frame.size.height - barImageView.frame.height - 130)
        
        detailImageView.frame = CGRect(x: 120,
                                       y: 30,
                                       width: 100,
                                       height: 100)
        
        nameLabel.frame = CGRect(x: -10 ,
                                 y: 120,
                                 width: view.frame.width,
                                 height: 60)
        
        describeLabel.frame = CGRect(x: 30,
                                     y: 180,
                                     width: detailView.frame.width - 60,
                                     height: detailView.frame.width/3)
        
        characView.frame = CGRect(x: 30,
                                  y: 300,
                                  width: detailView.frame.width/2.4,
                                  height: detailView.frame.width/5)
        
        characLabel.frame = CGRect(x: 20,
                                   y: 10,
                                   width: 100,
                                   height: 20)
        
        characDescLabel.frame = CGRect(x: 5,
                                       y: 30,
                                       width: 120,
                                       height: 40)
        
        statusView.frame = CGRect(x: 172,
                                  y: 300,
                                  width: detailView.frame.width/2.4,
                                  height: detailView.frame.width/5)
        
        statusLabel.frame = CGRect(x: 20,
                                   y: 10,
                                   width: 100,
                                   height: 20)
        
        statusDescLabel.frame = CGRect(x: 10,
                                       y: 30,
                                       width: 120,
                                       height: 40)
        shareButton.frame = CGRect(x: detailView.frame.maxX-90,
                                   y: detailView.frame.maxY-180,
                                   width: 60,
                                   height: 38)
        closeButton.frame = CGRect(x: detailView.frame.maxX-60,
                                   y: -5,
                                   width: 50,
                                   height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }// end of view did appear
    
    
    private func getHeadImage(){
              DataManager.instance.getUserImage { (image) in
                  DispatchQueue.main.async {
                      self.headImageView.image = image
                  }
              }
          }

    //圖片下載
    private func getImageDownload(){
        if let urlStr = piggy.url {
            if let url = URL(string: urlStr){
                let task = session?.downloadTask(with: url, completionHandler: {
                    (url, respons, error) in
                    
                    // error
                    if error != nil {
                        let errorCode = (error! as NSError).code
                        if errorCode == -1009 {
                            print("no internet connection")
                        }else {
                            print(error!.localizedDescription)
                        }
                        return
                    }
                    
                    // success
                    if let loadedURL = url {
                        do {
                            if let loadedImage = UIImage(data: try Data(contentsOf: loadedURL)){
                                print("loadedImage success")
                                DispatchQueue.main.async {
                                    self.detailImageView.image = loadedImage
                                    self.heartLabel.text = String(DataManager.instance.getHeart())
                                    self.starLabel.text = String(DataManager.instance.getStar())
                                    self.nameLabel.text = self.piggy.title
                                    self.describeLabel.text = self.piggy.desc
                                    self.characDescLabel.text = self.piggy.expect
                                    self.statusDescLabel.text = self.piggy.trait
                                    
                                    
                                }
                                
                            }
                            
                        } catch{
                            print(error.localizedDescription)
                        }
                        DispatchQueue.main.async {
//                            self.imageView.reloadInputViews()
                        }
                    }
                })
                task?.resume()
            }
            
        }
    }
    
     @objc func didTapCross(_ sender: UIButton) {
    //        let vc = storyboard?.instantiateViewController(identifier: "course") as! CourseViewController
            dismiss(animated: true, completion: nil)
        }
    @objc func didTapShare(_ sender: UIButton){
        let activityController = UIActivityViewController(activityItems: [self.nameLabel.text!, self.detailImageView.image!],applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

}// end of class
