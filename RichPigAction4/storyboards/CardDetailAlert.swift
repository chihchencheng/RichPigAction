//
//  CardDetailAlert.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/23.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class CardDetailAlert: UIViewController {
    static let identifier = "CardDetailAlert"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var describeText: UITextView!
    @IBOutlet weak var charLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfo(index: index)
     
    }
    
    func setupInfo(index: Int) {
        let url = MyUrl.pigCard.rawValue
        
        DispatchQueue.main.async {
//            self.imageView.image = DataManager.instance.getHeadImage()
//            self.nameLabel.text = DataManager.instance.getPiggy().title
//            self.describeText.text = DataManager.instance.getPiggy().desc
//            self.charLabel.text = DataManager.instance.getPiggy().expect
//            self.statusLabel.text = DataManager.instance.getPiggy().trait
        }
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShare(_ sender: UIButton) {
        let activityController = UIActivityViewController(activityItems: [self.nameLabel.text!, self.imageView.image!],applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    

}
