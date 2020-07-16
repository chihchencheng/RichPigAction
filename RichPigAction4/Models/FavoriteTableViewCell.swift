//
//  FavoriteTableViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/15.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet var myImageView: UIImageView!
    static let identifier = "FavoriteTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "FavoriteTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with imageName: String){
        myImageView.image = UIImage(named: imageName)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
