//
//  BookCollectionViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
     static let identifier = "BookCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var courseTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image: UIImage, course: String) {
           imageView.image = image
           courseTitleLabel.text = course
       }
       
       public func setTitle(course: String){
           courseTitleLabel.text = course
       }

       static func nib() -> UINib {
           return UINib(nibName: "BookCollectionViewCell", bundle: nil)
       }

}
