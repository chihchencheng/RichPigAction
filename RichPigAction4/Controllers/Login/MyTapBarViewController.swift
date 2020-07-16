//
//  MyTapBarViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/16.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class MyTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let levelVC = LevelViewController()
        self.present(levelVC, animated: false)
    }
    
    private func setup(){
        
        
    }


}
