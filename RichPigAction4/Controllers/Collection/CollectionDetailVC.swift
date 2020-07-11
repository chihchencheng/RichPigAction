//
//  CollectionDetailVC.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CollectionDetailVC: UIViewController {
    var piggy = Piggy()
    var image = UIImage()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var charaLabel: UILabel!
    @IBOutlet weak var charaDescLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusDescLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = image
        titleLabel.text = piggy.title
        descLabel.text = piggy.desc
        charaLabel.text = "特質"
        charaLabel.text = piggy.trait
        statusLabel.text = "狀態"
        statusDescLabel.text = piggy.expect
    }
    


}
