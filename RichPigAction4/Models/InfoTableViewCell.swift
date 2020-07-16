//
//  InfoTableViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/15.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class InfoTableViewCell: UITableViewCell {
    
    static let identifier = "InfoTableViewCell"
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var courseName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }
    
    
    public func configure(with animation: Animation, course: String) {
        animationView.animation = animation
        courseName.text = course
        
    }
    
    public func setTitle(course: String){
        courseName.text = course
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
