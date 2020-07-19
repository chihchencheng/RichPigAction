//
//  PictureViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
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
    
    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet weak var headImageView: UIImageView!
//    @IBOutlet weak var heartLabel: UILabel!
//    @IBOutlet weak var starLabel: UILabel!
    
    var session: URLSession?
    var piggyArr = [Piggy]()
    var piggyPicArr = [UIImage]()
    var image = UIImage()//準備傳到細節頁
    var level = 0
    var piggy = Piggy()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 2
        collectionView.collectionViewLayout = layout
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PigCardCollectionViewCell.nib(), forCellWithReuseIdentifier: PigCardCollectionViewCell.identifier)
        session = URLSession(configuration: .default)
        
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
//           DataManager.instance.getUserImage { (image) in
//               DispatchQueue.main.async {
//                   self.headImageView.image = image
//               }
//           }
        self.headImageView.image = DataManager.instance.getHeadImage()
       }
    
    private func setupInfo(){
           self.starLabel.text = String(DataManager.instance.getStar())
           self.heartLabel.text = String(DataManager.instance.getHeart())
           self.level = DataManager.instance.getLevel()
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getHeadImage()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    //下載資料
    private func downloadInfo(){
        let url = (MyUrl.pigCard.rawValue)
        useTokenWithGet(url:url ){ data in
            self.parseJSON(pigData: data)
        }
        
    }
    
    func parseJSON(pigData: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PigData.self, from: pigData)
            if let arrCount = decodedData.message?.avatars?.count {
                let level = DataManager.instance.level ?? 1
                for item in 0...level { //arrCount-1
                    if let pig = decodedData.message?.avatars![item] {
                        self.piggyArr.append(pig)
                    }
                }
            }
//            self.getImageDownload(piggyArr: piggyArr)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print(piggyArr.count)
            
        } catch {
            print(error)
        }
    }
    
    //圖片下載
    private func getImageDownload(piggyArr: [Piggy]){
        let count = DataManager.instance.level ?? 1
        for item in 0...count {  //piggyArr.count-1
            if let urlStr = piggyArr[item].url {
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
                                    self.piggyPicArr.append(loadedImage)
                                }
                                
                            } catch{
                                print(error.localizedDescription)
                            }
                            DispatchQueue.main.async {
                                print(self.piggyArr.count)
                            }
                        }
                    })
                    task?.resume()
                }
                
            }
        }
        
    }
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func useTokenWithGet(url:String ,completion: @escaping (Data) -> Void){
        var request = URLRequest(url:URL(string:url)!)
        request.httpMethod = "GET"  //"Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJyaWNoUGlnIiwiaWF0IjoxNTk0MjkyODIzLCJleHAiOjE1OTQzNzkyMjN9.T822HM56DAZhVeacPhI_2EhcnGZIJk6-xQmJWhIAs4rCpBVC9MO3KjpXzk-zypE4-ZYeEYsj-q7OmHT86YWC4Q"
        request.setValue("Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJyaWNoUGlnIiwiaWF0IjoxNTk0NDc1MzM3LCJleHAiOjE1OTk2NTkzMzd9.Zev2q2Jxz4GoTTd3OO1y1eXgDMs9k8iU_W62b-C39HeHbV_OEHGSpxhjBrWkWJY5fBi10qLGkxSGsyq6Iz6Huw", forHTTPHeaderField: "Authorization")
        //        print(NetworkController.token)
        
        let task = URLSession.shared.dataTask(with: request){ data,response ,error in
            guard let data = data , error == nil else{
                print("發送失敗！",error?.localizedDescription ?? "data不存在")
                return
            }
            let str  = "發送成功" //+ String(data: data,encoding: .utf8)!
            print(str)
            completion(data)
        }
        task.resume()
    }
    
}// end of class


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                //let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

// help to pick up interacton with the cells
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapeed me")
        self.piggy = piggyArr[indexPath.row]
//        self.image = piggyPicArr[indexPath.row]
        performSegue(withIdentifier: "cardDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardDetail" {
            let dvc = segue.destination as? CollectionDetailVC
            dvc?.piggy = self.piggy
//            dvc?.image = self.image
        }
    }
    
}


extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return piggyArr.count //level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PigCardCollectionViewCell.identifier, for: indexPath) as! PigCardCollectionViewCell
        cell.pigNameLabel.text = piggyArr[indexPath.row].title
        cell.imageView.contentMode = .scaleAspectFill
        let link = String(piggyArr[indexPath.row].url ?? "")
        cell.imageView.downloaded(from: link)

        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
