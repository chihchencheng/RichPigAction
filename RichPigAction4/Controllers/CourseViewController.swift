//
//  CourseViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var session: URLSession?
    var bookArrTitle = [String]()
    var count = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(BookCollectionViewCell.nib(), forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        downloadInfo()
        
    }// end of view did load
    
    func downloadInfo(){
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
                        self.getCourseArr(okData)
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
    


    
    func popAler(withMessage message: String){
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    

}// end of class

extension CourseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.count = indexPath.row
//        performSegue(withIdentifier: "quiz", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "quiz" {
//            let dvc = segue.destination as? GameViewController
//            dvc?.level = self.level
//        }
    }
}



extension CourseViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  bookArrTitle.count//level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        let image = UIImage(systemName: "book.circle")
        image?.withTintColor(.green)
        cell.configure(with: image!, course: bookArrTitle[indexPath.row])// level[indexPath.row]
        return cell
    }
}

extension CourseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
