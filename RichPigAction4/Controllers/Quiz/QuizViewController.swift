//
//  QuizViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class QuizViewController: UIViewController {
    var totalTime = 20
    var secondsPassed = 0
    var timer = Timer()

    @IBOutlet weak var quizStartLabel: UILabel!
    @IBOutlet weak var quizHeartLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var progressBar: UIProgressView!
    
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
        collectionView.register(AnswerCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: AnswerCollectionViewCell.identifier)
       
        setupAnimation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        downloadInfo()
        print("quiz level:\(level)")
        
        progressBar.progress = 0.0
        secondsPassed = 0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        setupInfo()
    }// end of view did load
    
    func setupAnimation(){
        //        animationView = .init(name: "heartclock")
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    @objc func updateTimer2(){
        if secondsPassed < totalTime {
            secondsPassed += 1
//            if secondsPassed % 7 == 0 {
//                self.showToast(message: "加油喔")
//            }
            progressBar.progress =  (Float(secondsPassed) / Float(totalTime))
            print(progressBar.progress)
            
            
        } else {
            timer.invalidate()
//            showToast(message: "時間到，不給分")
            
//            popAler(withMessage: "時間到")
        }
    }
    
        @objc func updateTimer(){
            
            if totalTime >= 0 {
                totalTime -= 1
//                if totalTime % 7 == 0 {
//                    self.showToast(message: "加油喔")
//                }
                progressBar.progress =  (Float(totalTime) / Float(20))
                print(progressBar.progress)
                
                
            } else {
                timer.invalidate()
//                showToast(message: "時間到，不給分")
                
    //            popAler(withMessage: "時間到")
            }
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationView?.frame = CGRect(x: 20,
                                      y: 110,
                                      width: 60,
                                      height: 60 )
    }
    
    
    @IBAction func didTapCrossButton(){
        let vc = storyboard?.instantiateViewController(identifier: "level") as! LevelViewController
        
        vc.modalPresentationStyle = .fullScreen
        dismiss(animated: true, completion: nil)
//        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadInfo()
        setupInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupInfo(){
        self.quizStartLabel.text = String(DataManager.instance.getStar())
        self.quizHeartLabel.text = String(DataManager.instance.getHeart())
    }
    
    
    private func configureUI(questionSet: QuestionSet){
        titleLabel.text = questionSet.category
        currentQuestion = questionSet
        contentLabel.text = questionSet.question
        collectionView.reloadData()
        progressBar.setProgress(0, animated: false)
        
        secondsPassed = 0
        updateTimer()
//        progressBar.reloadInputViews()

    }
    
    //下載資料
    private func downloadInfo(){
        let url = MyUrl.tutorials.rawValue + "/\(UserDefaults.standard.integer(forKey: "level"))"
        NetworkController.getService.useTokenToGet(url: url) { (data) in
            do {
                let okData = try JSONDecoder().decode(SingleSetData.self, from: data)
                //解析資料並取得所需的題目array
                self.quizArr = self.quizSetArray(okData: okData)
                
                self.currentQuestion = self.quizArr[0]
                DispatchQueue.main.async {
                    self.configureUI(questionSet: self.currentQuestion ?? QuestionSet())
                }
            } catch {
                DispatchQueue.main.async {
                    self.popAler(withMessage: "Sorry, connection error")
                }
            }
        }
    }// end of download info

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
        if let cell = collectionView.cellForItem(at: indexPath) as? AnswerCollectionViewCell {
            if  checkAnswer(questionSet: question, selectItem: indexPath.row){
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
                        secondsPassed = 0
                        timer.invalidate()
                        guard let currentTime = Date().toMillis() else { return }
                        NetworkController.getService.updateInfo(level: 10, star: 50, dateTime: currentTime, loveTime: 2)
//                        NetworkController.getService.updateInfo(level: DataManager.instance.level ?? 5, star: DataManager.instance.getStar(), dateTime: currentTime, loveTime: DataManager.instance.getHeart())
                        let alert = UIAlertController(title: "Message",
                                                      message: "恭喜完成挑戰",
                                                      preferredStyle: UIAlertController.Style.alert)
                        let action = UIAlertAction(title: "OK", style: .default , handler: { // Also action dismisses AlertController when pressed.
                            action in
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                        )
                        alert.addAction(action)// add action to alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            } else {
                // wrong
                cell.setWrongAnswerImage()
                
                //popAler(withMessage: "Wrong answer")
            }
            
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
    return CGSize(width: view.frame.size.width/2.2, height: view.frame.size.width/4) // 180,150
   
//        return  CGSize(width: view.frame.size.width/3.2,
//                       height: view.frame.size.width/3.2)
   }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

//extension UIViewController {
//    func showToast(message: String){
//        guard let toastWindow = UIApplication.shared.keyWindow else {
//            return
//        }
//        let toastLbl = UILabel()
//        toastLbl.text = message
//        toastLbl.textAlignment = .center
//        toastLbl.font = UIFont.systemFont(ofSize: 12)
//        toastLbl.textColor = UIColor.black
//        toastLbl.backgroundColor = UIColor.white.withAlphaComponent(0.6)
//        toastLbl.numberOfLines = 0
//
//        let textSize = toastLbl.intrinsicContentSize
//        let labelWidth = min(textSize.width, toastWindow.frame.width - 40)
//
//        toastLbl.frame = CGRect(x: 20, y:
//            toastWindow.height - 70, width: labelWidth + 20,
//                                height: textSize.height + 20)
//        toastLbl.center.x = toastWindow.center.x
//        toastLbl.layer.cornerRadius = 10
//        toastLbl.layer.masksToBounds = true
//
//        toastWindow.addSubview(toastLbl)
//
//        UIView.animate(withDuration: 3.0,
//                       animations: {toastLbl.alpha = 0}) { (_) in
//                        toastLbl.removeFromSuperview()
//        }
//    }
//
//}

