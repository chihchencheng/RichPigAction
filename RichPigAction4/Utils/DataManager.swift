//
//  DataManager.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/13.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
  static var dataManager: DataManager?
    var token = ""
//    "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJyaWNoUGlnIiwiaWF0IjoxNTk0NDc1MzM3LCJleHAiOjE1OTk2NTkzMzd9.Zev2q2Jxz4GoTTd3OO1y1eXgDMs9k8iU_W62b-C39HeHbV_OEHGSpxhjBrWkWJY5fBi10qLGkxSGsyq6Iz6Huw"
    var level: Int?
    var star: Int?
    var dateTime: Int64?
    var loveTime: Int?
    var user: UserInfo?
    var image: UIImage?
    var username: String?
    var email: String?
    var name: String?
    
    
    
    fileprivate init(){}
    
    
    static var instance: DataManager {
        get{
            if dataManager == nil {
                self.dataManager = DataManager()
            }
            return self.dataManager!
        }
    }
    
    func setToken(token: String){
        DataManager.instance.token = token
    }
    
    func getToken() -> String {
        return DataManager.instance.token
    }
    
    func setStar(star: Int){
        DataManager.instance.star = star
    }
    
    func getStar() -> Int{
        return DataManager.instance.star ?? 0
    }
    
    func setHeart(heart: Int){
        DataManager.instance.loveTime = heart
    }
    
    
    func getHeart() -> Int {
//        print("================")
//        print(DataManager.instance.loveTime)
        return DataManager.instance.loveTime ?? 0
    }
    
    func setLevel(level: Int) {
        DataManager.instance.level = level
    }
    
    func getLevel() -> Int {
        return DataManager.instance.level ?? 0
    }
    
    func updateUserInfo(callBack: @escaping () -> Void){
        NetworkController.getService.getUserInfoWithToken(token: DataManager.instance.getToken(),callback: { Rjson in
            if Rjson["status"] as? Int ?? -1 == 200 {
                let json = Rjson["message"] as? [String:Any] ?? ["":""]

                DataManager.dataManager?.star = json["star"] as? Int ?? 0
                    DataManager.dataManager?.loveTime = json["loveTime"] as? Int ?? 0
                    DataManager.dataManager?.level = json["level"] as? Int ?? 0
                    DataManager.dataManager?.username = json["username"] as? String ?? "Pig"
                    DataManager.dataManager?.email = json["email"] as? String ?? "Email"
                    DataManager.dataManager?.name = json["name"] as? String ?? "Name"
                    DataManager.dataManager?.dateTime = json["dateTime"] as? Int64 ?? 99
                    DispatchQueue.main.async {
                         callBack()
                    }
                   
                  }
            })
         

        
    }
    
    func getUserImage(completion: @escaping (UIImage) -> Void){
        NetworkController.getService.getHeadImagebyLevel { (data) in
            do{
                if let okData = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String:Any])
                {
                    let msg = okData["message"]  as? [String:Any] ?? ["":""]
                    let url =  msg["url"] as? String
                    NetworkController.getService.dowloadImage(url: url!, completion: completion)
                }
            }
        }
//        
    }
}


