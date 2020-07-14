//
//  QuestionTableViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/13.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    static let identifier = "QuestionTableViewCell"
    
    @IBOutlet weak var qImageView: UIImageView!
    
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
