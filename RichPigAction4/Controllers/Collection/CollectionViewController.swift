//
//  PictureViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var session: URLSession?
    var piggyArr = [Piggy]()
    var piggyPicArr = [UIImage]()
    var image = UIImage()//準備傳到細節頁
    var piggy = Piggy()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    }// end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        downloadInfo()
//        getImageDownload(piggyArr: piggyArr)
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
                for item in 0...arrCount-1 {
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
        for item in 0...piggyArr.count-1 {
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
        self.image = piggyPicArr[indexPath.row]
        performSegue(withIdentifier: "cardDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cardDetail" {
            let dvc = segue.destination as? CollectionDetailVC
            dvc?.piggy = self.piggy
            dvc?.image = self.image
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
