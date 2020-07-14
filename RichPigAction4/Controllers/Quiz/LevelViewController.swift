//
//  LevelViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbHeartAmount: UILabel!
    @IBOutlet weak var lbStarAmount: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    let alertService = AlertService()
    
    var level = 0
    var session: URLSession?
    var noseArr = [String]()
    var singleArr = [SingleData]()
    var quizArr = [Quiz]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(NoseCollectionViewCell.nib(), forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self

        
            NetworkController.getService.getUserInfoWithToken(token: DataManager.instance.getToken(),callback: { json in
                DataManager.instance.setStar(star: json["star"] as? Int ?? -1)
                
                DispatchQueue.main.async {
                    self.setupInfo()
                }
            })
        downloadInfo()
        
    }// end of view did load
    
    
    private func setupInfo(){
        self.lbStarAmount.text = String(DataManager.instance.getStar())
        self.lbHeartAmount.text = String(DataManager.instance.getHeart())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "logged_in"){
            downloadInfo()
        }
        setupInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadInfo()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func downloadInfo(){
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
                    self.popAler(withMessage: "Sorry")
                }
            }
        }
    }// end of download info

    
//    func downloadInfo(){
//        //        session = URLSession(configuration: .default)
//        if let url = URL(string: MyUrl.tutorials.rawValue){
//            let task = session?.dataTask(with: url, completionHandler: {
//                (data, response, error) in
//
//                if error != nil {
//                    let errorCode = (error! as NSError).code
//                    if errorCode == -1009 {
//                        DispatchQueue.main.async {
//                            self.popAler(withMessage: "No internet connection")
//                        }
//                        print("No internet connection")
//                    } else {
//                        DispatchQueue.main.async {
//                            self.popAler(withMessage: String(errorCode))
//                        }
//                        print("Something is wrong")
//                    }
//                    return
//                } // end of error
//
//
//                if let loadedData = data {
//                    do {
//                        let okData = try JSONDecoder().decode(AllData.self, from: loadedData)
//                        self.noseArr = self.updateLevelLabel(okData)
//                        self.getAllQuizArray(okData)
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//
//                    } catch {
//                        DispatchQueue.main.async {
//                            self.popAler(withMessage: "Sorry")
//                        }
//                    }
//                }// end of data operation
//
//            })
//            task?.resume()
//        }
//    }
    
    //取得quize的陣列
    func getAllQuizArray(_ okData: AllData){
        if let okSingle = okData.message {
            self.singleArr = okSingle
//            print("testing singleArr\(singleArr)")
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
            let id = okData.message?[item].id
            noseArr.append("\(id ?? 0)")
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
        let title = "Level: \(self.singleArr[indexPath.row].id ?? 0)"
        let body = self.singleArr[indexPath.row].title ?? "Data Error"
        let alertVC = alertService.alert(title: title , body: body, buttonTitle: "開始") {
            let vc = (self.storyboard?.instantiateViewController(identifier: "QuizViewController"))! as QuizViewController
            DispatchQueue.main.async {
                let heart = DataManager.instance.getHeart()-1
                DataManager.instance.setHear(heart: heart)
                self.lbHeartAmount.text = (String)(heart)
            }
            UserDefaults.standard.set(indexPath.row, forKey: "level")
            self.present(vc, animated: true)
        }
        
            self.present(alertVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quiz" {
            let dvc = segue.destination as? QuizViewController
            dvc?.level = self.level
        }
    }
}



extension LevelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return noseArr.count //level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as! NoseCollectionViewCell
        cell.configure(with: UIImage(named: "nose1")!, level: noseArr[indexPath.row])// level[indexPath.row]
        return cell
    }
}

extension LevelViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
