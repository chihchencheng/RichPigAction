//
//  CodedTableViewCell.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/15.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CodedTableViewCell: UITableViewCell {
    
    static let identifier = "CodedTableViewCell"
    
    private let myLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let myImageView: UIImageView = {
        let myImageView = UIImageView()
        return myImageView
    }()
    
    public func configure(with imageName: String){
        contentView.addSubview(myLabel)
        contentView.addSubview(myImageView)
        
        myLabel.text = "It works"
        myLabel.textAlignment = .center
        myImageView.image = UIImage(named: imageName)
        myImageView.contentMode = .scaleAspectFill
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.frame = CGRect(x: 5, y: 5, width: 100, height: 100)
        myLabel.frame = CGRect(x: 105, y: 5, width: contentView.frame.size.width-105, height: 100)
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 50.0
    }
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
