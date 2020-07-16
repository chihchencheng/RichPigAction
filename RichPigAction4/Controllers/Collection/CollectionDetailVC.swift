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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var charaLabel: UILabel!
    @IBOutlet weak var charaDescLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        getImageDownload()

    }// end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = image
        titleLabel.text = piggy.title
        descLabel.text = piggy.desc
        charaLabel.text = "特質"
        charaDescLabel.text = piggy.trait
        statusLabel.text = "狀態"
        statusDescLabel.text = piggy.expect
        getImageDownload()
    }// end of view did appear
    

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
                                self.image = loadedImage
                            }
                            
                        } catch{
                            print(error.localizedDescription)
                        }
                        DispatchQueue.main.async {
                            self.imageView.reloadInputViews()
                        }
                    }
                })
                task?.resume()
            }
            
        }
    }
    
     @IBAction func backToCollection(_ sender: UIButton) {
    //        let vc = storyboard?.instantiateViewController(identifier: "course") as! CourseViewController
            dismiss(animated: true, completion: nil)
        }

}// end of class
