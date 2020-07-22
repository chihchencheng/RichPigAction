//
//  QuizViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie
import Toast_Swift

class QuizViewController: UIViewController {
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
        label.text = String(DataManager.instance.getHeart())
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
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var animationView: AnimationView?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var headImage: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    var totalTime = 20
    var secondsLeft = 20
    var selectTimes = 0
    var timer = Timer()
    var isSelected = [Bool]()
    
    private var star = DataManager.instance.getStar()
    private var heart = DataManager.instance.getHeart()
    private var level = DataManager.instance.getLevel()
    
    
    var session: URLSession?
    
    var quizArr = [QuestionSet]()
    var quizes: [Quiz]?
    var currentQuestion: QuestionSet?
    var options = [String]()
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
        
        // 下載課程、使用者資訊、等級小豬圖片
        downloadInfo()
        
        progressBar.progress = 0.0
        secondsLeft = 20
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
        
        view.addSubview(scrollView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(barImageView)
        
        barImageView.addSubview(heartImageView)
        barImageView.addSubview(heartLabel)
        barImageView.addSubview(headImageView)
        barImageView.addSubview(starImageView)
        barImageView.addSubview(starLabel)
        view.bringSubviewToFront(collectionView)
        view.bringSubviewToFront(btnBack)
        view.bringSubviewToFront(progressBar)
        view.bringSubviewToFront(animationView!)
        
       
        self.headImageView.image = DataManager.instance.getHeadImage()
    }// end of view did load
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animationView?.frame = CGRect(x: 20,
                                      y: 110,
                                      width: 60,
                                      height: 60 )
//        self.progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 2)
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
        
        starImageView.frame = CGRect(x: 220,
                                     y: 20,
                                     width: 70,
                                     height: 70)
        starLabel.frame = CGRect(x: 295,
                                 y: 15,
                                 width: 70,
                                 height: 70)
        progressBar.layer.cornerRadius = 12
        progressBar.layer.borderWidth = 5
        progressBar.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        progressBar.layer.sublayers![1].cornerRadius = 12
        progressBar.subviews[1].clipsToBounds = true
    }
    
    
    @IBAction func didTapCrossButton(){
        let vc = storyboard?.instantiateViewController(identifier: "level") as! LevelViewController
        vc.modalPresentationStyle = .fullScreen
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.heartLabel.text = String(DataManager.instance.getHeart())
        self.starLabel.text = String(DataManager.instance.getStar())
        DataManager.instance.getUserImage { (image) in
            DispatchQueue.main.sync {
                self.headImageView.image = image
            }
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func setupAnimation(){
        //        animationView = .init(name: "heartclock")
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    
    @objc func updateTimer(){
        if secondsLeft >= 0 {
            secondsLeft -= 1
            progressBar.progress =  (Float(secondsLeft) / Float(totalTime))
            if secondsLeft == 10 {
                self.view.makeToast("加油喔！", duration: 1.0, position: .bottom)
            }
            if secondsLeft == 0 {
                self.view.makeToast("時間到，不給分！", duration: 1.0, position: .center)
            }
        } else {
            timer.invalidate()
        }
    }


    private func configureUI(questionSet: QuestionSet){
        titleLabel.text = questionSet.category
        currentQuestion = questionSet
        contentLabel.text = questionSet.question
        collectionView.reloadData()
        progressBar.setProgress(0, animated: false)
        secondsLeft = 20
        updateTimer()
    }
    
    //下載資料
    private func downloadInfo(){
        let url = MyUrl.tutorials.rawValue + "/\(UserDefaults.standard.integer(forKey: "gameLevel"))"
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
    
    //quize判斷
    private func addingStars(selectTimes: Int){
        if secondsLeft > 0 || selectTimes < 4 {
            switch selectTimes {
            case 1:
                self.star += 10
                break
            case 2:
                self.star += 8
                 break
            case 3:
                self.star += 4
                 break
            default:
                self.star += 0
                 break
            }
        }
    }


}// end of class

extension QuizViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let question = currentQuestion else {
            return
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? AnswerCollectionViewCell {
            self.selectTimes += 1
            if  checkAnswer(questionSet: question, selectItem: indexPath.row){
                
                // next question
                if let index = quizArr.firstIndex(where: {$0.question == question.question}){
                    if index < (quizArr.count-1){
                        // next game
                        let nextQuestion = quizArr[index + 1]
                        
                        currentQuestion = nil
                        addingStars(selectTimes: self.selectTimes)
                        self.configureUI(questionSet: nextQuestion)
                        selectTimes = 0
                    }else{
                        // end of game
//                        secondsLeft = 20
                        timer.invalidate()
                        if UserDefaults.standard.integer(forKey: "gameLevel") == DataManager.instance.getLevel(){
                            self.level += 1
                            print("testing level updating \(self.level)")
                        }
                        let totalGainStars = self.star - DataManager.instance.getStar()
                        UserDefaults.standard.set(self.level, forKey: "level")
                        DataManager.instance.setLevel(level: self.level)
                        DataManager.instance.setStar(star: self.star)
                        NetworkController.getService.dowloadImage(url: MyUrl.pigCard.rawValue+"/\(String(self.level))") { (image) in
                            DataManager.instance.setHeadImage(image: image)
                        }
                        
                        guard let currentTime = Date().toMillis() else { return }
                        print("currentTime\(currentTime)")
                        
                        //答題結束回傳給後端更新的資料
                        NetworkController.getService.updateInfo(level: DataManager.instance.getLevel(),
                                                                star: DataManager.instance.getStar(),
                                                                dateTime: currentTime,
                                                                loveTime: DataManager.instance.getHeart())
                        
                        
                        let alert = UIAlertController(title: "Message",
                                                      message: "恭喜完成挑戰，總共獲得\(totalGainStars)顆星星，以及新的小豬圖鑑喔，快去看看吧",
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
                isSelected[indexPath.row] = true
                self.view.makeToast("答錯了，再試試！", duration: 0.5, position: .center)
            }
            
        }
    }
}


extension QuizViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = currentQuestion?.options?.count ?? 0
        self.isSelected = [Bool](repeating: false, count: count)
        return count//level.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnswerCollectionViewCell.identifier, for: indexPath) as! AnswerCollectionViewCell
        if isSelected[indexPath.row] {
            cell.configure(with: UIImage(named: "btnAnswer3")!, answer: (currentQuestion?.options?[indexPath.row])!)
        } else {
            cell.configure(with: UIImage(named: "btnAnswer1")!, answer: (currentQuestion?.options?[indexPath.row])!)// level[indexPath.row]
        }
        
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
//


