//
//  NoseCollectionViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class NoseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NoseCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbLevel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with image: UIImage, level: String) {
        imageView.image = image
        lbLevel.text = level
    }
    
    public func setLevel(level: String){
        lbLevel.text = level
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "NoseCollectionViewCell", bundle: nil)
    }
    
}
