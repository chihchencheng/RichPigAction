//
//  BookCollectionViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class BookCollectionViewCell: UICollectionViewCell {
     static let identifier = "BookCollectionViewCell"
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
//        animationView!.animationSpeed = 0.5
        
        animationView!.play()
        
        
        
    }
    
    
    public func configure(with animation: Animation, course: String) {
//           imageView.image = image
            animationView.animation = animation
           courseTitleLabel.text = course
       
       }
       
    func rePlay(){
        animationView!.loopMode = .loop
         animationView!.play()
    }
    
       public func setTitle(course: String){
           courseTitleLabel.text = course
       }

       static func nib() -> UINib {
           return UINib(nibName: "BookCollectionViewCell", bundle: nil)
       }

}
