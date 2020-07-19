//
//  Modify.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/19.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class Modify: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var nameTxF: UITextField!
    @IBOutlet weak var emailTxF: UITextField!
    
    var buttonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        
    }
    
  
    @IBAction func didTapCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
