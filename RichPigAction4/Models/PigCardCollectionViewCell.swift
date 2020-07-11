//
//  PigCardCollectionViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class PigCardCollectionViewCell: UICollectionViewCell {
    static let identifier = "PigCardCollectionViewCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pigNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image: UIImage, name: String) {
              imageView.image = image
              pigNameLabel.text = name
          }
          
          public func setTitle(name: String){
              pigNameLabel.text = name
          }

          static func nib() -> UINib {
            return UINib(nibName: PigCardCollectionViewCell.identifier, bundle: nil)
          }

}
