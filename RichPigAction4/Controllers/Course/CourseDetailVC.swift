//
//  CourseDetailVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import iCarousel

class CourseDetailVC: UIViewController, iCarouselDataSource {

    var session: URLSession?
    var courseArr = [Course]()
    var allCourseArr = [[Course]]()
    var imgArr = [UIImage]()
    var index = 0
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myCarousel)
        myCarousel.dataSource = self
        //        myCarousel.autoscroll = -0.3
        myCarousel.frame = CGRect(x: 0,
                                  y: 100,
                                  width: view.frame.size.width,
                                  height: 400)
        session = URLSession(configuration: .default)
        getImageDownload()
        
    }// end of view did load
    
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
                            print(loadedURL)
                            if let loadedImage = UIImage(data: try Data(contentsOf: loadedURL)){
                                //                                print("loadedImage success")
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
    
    @IBAction func backToCourse(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "course") as! CourseViewController
        dismiss(animated: true, completion: nil)
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.size.width - 10, height: 350))
        view.backgroundColor = .white
        let imageView = UIImageView(frame: view.bounds)
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
