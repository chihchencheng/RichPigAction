//
//  InfoViewController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit
import Lottie

class InfoViewController: UIViewController {
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteCourse = ["Love"]//[String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
//        let login = LoginViewViewController()
//
//        self.present(login, animated: true) {
//            UserDefaults.standard.set(false, forKey: "Logged_in")
//            self.dismiss(animated: true, completion: nil)
//        }
             
    }
    
    @IBAction func didTapModify(_ sender: UIButton) {
        
    }
    
}// end of class

extension InfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = favoriteCourse[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//        return 50
//    }

}

extension InfoViewController: UITableViewDelegate {
    
}
