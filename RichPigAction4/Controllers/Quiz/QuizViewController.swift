//
//  QuizViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    var options = [String]()
    var session: URLSession?
    var quizArr = [QuestionSet]()
    var level = 0
    var quizes: [Quiz]?
    var currentQuestion: QuestionSet?
    var courseArr = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: .default)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 180)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(AnswerCollectionViewCell.nib(), forCellWithReuseIdentifier: AnswerCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        

        
    }// end of view did load
    
    override func viewDidAppear(_ animated: Bool) {
        downloadInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    private func configureUI(questionSet: QuestionSet){
        titleLabel.text = questionSet.category
        currentQuestion = questionSet
        contentLabel.text = questionSet.question
        collectionView.reloadData()
        
    }
    
    //下載資料
    private func downloadInfo(){
        if let url = URL(string: MyUrl.tutorials.rawValue + "/\(level )"){
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
                        let okData = try JSONDecoder().decode(SingleSetData.self, from: loadedData)
                        //解析資料並取得所需的題目array
                        self.quizArr = self.quizSetArray(okData: okData)
//                        print("成功解析題目並取得資料\(self.quizArr)")
                        self.currentQuestion = self.quizArr[0]
                        DispatchQueue.main.async {
                            self.configureUI(questionSet: self.currentQuestion ?? QuestionSet())
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.popAler(withMessage: "Sorry, connection error")
                        }
                    }
                }// end of data operation
            })
            task?.resume()
        }
    }
    
    
    //解析為Quiz的array，並將選項解析為str的array
    func quizSetArray(okData: SingleSetData) -> [QuestionSet]{
        let quizArray = okData.message?.quizzes
        let length = quizArray?.count
        var questionSets = [QuestionSet]()
        if let oklength = length {
            for item in 0...oklength-1 {
                let category = quizArray?[item].category
                let question = quizArray?[item].question
                let options = quizArray?[item].options
                let strOptionsArr = self.splitOptions(options: options ?? "")
                self.options = strOptionsArr
                let ans = quizArray?[item].ans
                let levelQ = QuestionSet(category: category, question: question, options: strOptionsArr, answer: ans)
                questionSets.append(levelQ)
            }
        }
        return questionSets
    }
    
    // 判斷是否為正確選項
    func checkAnswer(questionSet: QuestionSet, selectItem: Int) -> Bool{
        return questionSet.answer == selectItem
    }
    
    //切割選項成為選項array
    func splitOptions(options: String) -> [String] {
        let strArr = options.split(separator: ",")
        var newStrArr = [String]()
        for item in 0...strArr.count-1 {
            let str = "" + strArr[item]
            newStrArr.append(str)
        }
        return newStrArr
    }
    
    func popAler(withMessage message: String){
           let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
   


}// end of class

extension QuizViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let question = currentQuestion else {
            return
        }
        if checkAnswer(questionSet: question, selectItem: indexPath.row){
            // next question
            if let index = quizArr.firstIndex(where: {$0.question == question.question}){
                if index < (quizArr.count-1){
                    // next game
                    let nextQuestion = quizArr[index + 1]
                    //                    print("next Question:\(nextQuestion)")
                    currentQuestion = nil
                    self.configureUI(questionSet: nextQuestion)
                }else{
                    // end of game
//                    popAler(withMessage: "恭喜完成挑戰")
//                    dismiss(animated: true, completion: nil)
                    let vc = storyboard?.instantiateViewController(identifier: "level") as! LevelViewController
//                    vc.modalPresentationStyle = .fullScreen
                    present(vc, animated: true, completion: nil)
//                    performSegue(withIdentifier: "quiz", sender: nil)
//                                        dismiss(animated: true, completion: nil)
                }
            }
        } else {
            // wrong
            popAler(withMessage: "Wrong answer")
        }
    }
}


extension QuizViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return currentQuestion?.options?.count ?? 0//level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.identifier, for: indexPath) as! AnswerCollectionViewCell
      
        
        cell.configure(with: UIImage(named: "btnAnswer1")!, answer: (currentQuestion?.options?[indexPath.row])!)// level[indexPath.row]
        return cell
    }
    
}

extension QuizViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collecitonViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 180, height: 150)
   }
}


