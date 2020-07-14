//
//  GameViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie
import MobileCoreServices

class GameViewController: UIViewController, UIDropInteractionDelegate {
    var questions = ["用來衡量自己所能承受的風險等級及適合的投資風格",
                     "ETF 最主要的配息來源",
                     "「不要把所有的雞蛋放在同一個籃子」的涵義",
                     "不工作也能賺到的現金流收入"]
    var level = 0
    var quizArr = [Quiz]()
    private var animationView: AnimationView?
    @IBOutlet weak var questionTableView1: UITableView!
    
    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTableView1.delegate = self
        questionTableView1.dataSource = self
        
        animationView = .init(name: "pig")
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()

        registerNibs()
        
    }// end of view did load
    
    private func registerNibs(){
        let qnib = UINib(nibName: QuestionTableViewCell.identifier, bundle: nil)
        questionTableView1.register(qnib, forCellReuseIdentifier: QuestionTableViewCell.identifier)
        
//        let asnib = UINib(nibName: AnswerTableViewCell.identifier, bundle: nil)
//        answerTableView1.register(asnib, forCellReuseIdentifier: AnswerTableViewCell.identifier)
//
//        let anib = UINib(nibName: AnswerCollectionViewCell.identifier, bundle: nil)
//        totalAnswerCollectionView.register(anib, forCellWithReuseIdentifier: AnswerCollectionViewCell.identifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationView?.frame = CGRect(x: 230,
                                      y: 620,
                                      width: 150,
                                      height: 150 )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }


}// end of class


extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if tableView == questionTableView1 {
        let cell = questionTableView1.dequeueReusableCell(withIdentifier: QuestionTableViewCell.identifier, for: indexPath) as! QuestionTableViewCell
        cell.textLabel?.text = questions[indexPath.row]
        return cell
    }
    
}
extension GameViewController: UITableViewDelegate {
    
}

//extension GameViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return answers.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = totalAnswerCollectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.identifier, for: indexPath) as! AnswerCollectionViewCell
//        cell.aLabel?.text = answers[indexPath.row]
//        return cell
//    }
//}

extension GameViewController: UICollectionViewDelegate {
    
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds
        return CGSize(width: size.width/2, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}// end of collection delegate flow layout


// -MARK: Dragable Setting

//extension GameViewController: UITableViewDragDelegate {
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let string = answers[indexPath.row]
//        guard let data = string.data(using: .utf8) else { return [] }
//        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
//
//        return [UIDragItem(itemProvider: itemProvider)]
//    }
    
    
//}



//        if let url = URL(string: MyUrl.tutorials.rawValue + "/\(level )"){
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
//                if let loadedData = data {
//                    do {
//                        let okData = try JSONDecoder().decode(SingleSetData.self, from: loadedData)
//                        //解析資料並取得所需的題目array
//                        self.quizArr = self.quizSetArray(okData: okData)
////                        print("成功解析題目並取得資料\(self.quizArr)")
//                        self.currentQuestion = self.quizArr[0]
//                        DispatchQueue.main.async {
//                            self.configureUI(questionSet: self.currentQuestion ?? QuestionSet())
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            self.popAler(withMessage: "Sorry, connection error")
//                        }
//                    }
//                }// end of data operation
//            })
//            task?.resume()
//        }
//    }
