//
//  AnswerCollectionViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    static let identifier = "AnswerCollectionViewCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var answerLabel: UILabel!
    var answerView1 = UIImage()
    var answerView2 = UIImage()
    var answerView3 = UIImage()

    override func awakeFromNib() {
        super.awakeFromNib()
        answerView1 = UIImage(named: "btnAnswer1")!
        answerView2 = UIImage(named: "btnAnswer2")!
        answerView3 = UIImage(named: "btnAnswer3")!
        
    }
    
    public func configure(with image: UIImage, answer: String) {
        imageView.image = image
        answerLabel.text = answer
    }
    
    public func setAnswer(answer: String){
        answerLabel.text = answer
    }
    
    static func nib() -> UINib {
        return UINib(nibName: AnswerCollectionViewCell.identifier, bundle: nil)
    }

}
