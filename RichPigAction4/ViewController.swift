//
//  ViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/10.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkController.requestWithUrl(url: MyUrl.tutorials.rawValue ) { (data) in
            
            do {
                let okData = try JSONDecoder().decode(AllData.self, from: data)
                print("解析成功：\(okData)")
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }// end of view did load


}// end of class

