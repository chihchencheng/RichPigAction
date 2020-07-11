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
    
    var level = 0
    var session: URLSession?
    var noseArr = [String]()
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
        downloadInfo()
        
    }// end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "logged_in"){
            downloadInfo()
        }
        
    }
    
    func downloadInfo(){
        //        session = URLSession(configuration: .default)
        if let url = URL(string: MyUrl.tutorials.rawValue){
            let task = session?.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009 {
                        DispatchQueue.main.async {
                            self.popAler(withMessage: "No internet connection")
                        }
                        print("No internet connection")
                    } else {
                        DispatchQueue.main.async {
                            self.popAler(withMessage: String(errorCode))
                        }
                        print("Something is wrong")
                    }
                    return
                } // end of error
                
                
                if let loadedData = data {
                    do {
                        let okData = try JSONDecoder().decode(AllData.self, from: loadedData)
                        self.noseArr = self.updateLevelLabel(okData)
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    } catch {
                        DispatchQueue.main.async {
                            self.popAler(withMessage: "Sorry")
                        }
                    }
                }// end of data operation
                
            })
            task?.resume()
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
        //        print(noseArr)
        //        noseArr.sort()
        return noseArr
        
        //        print(noseArr)
    }
    
    
    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}// end of class

extension LevelViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if quizArr[indexPath.row].type == 0 || quizArr[indexPath.row].type == 1 {
            performSegue(withIdentifier: "quiz", sender: nil)
//        } else if quizArr[level].type == 2 {
//            performSegue(withIdentifier: "game", sender: nil)
//        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quiz" {
            let dvc = segue.destination as? QuizViewController
            dvc?.level = self.level
        }
        if segue.identifier == "game" {
            let dvc = segue.destination as? GameViewController
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
