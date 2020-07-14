//
//  DataManager.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/13.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation

class DataManager {
  static var dataManager: DataManager?
    var token = ""
//    "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJyaWNoUGlnIiwiaWF0IjoxNTk0NDc1MzM3LCJleHAiOjE1OTk2NTkzMzd9.Zev2q2Jxz4GoTTd3OO1y1eXgDMs9k8iU_W62b-C39HeHbV_OEHGSpxhjBrWkWJY5fBi10qLGkxSGsyq6Iz6Huw"
    var level: Int?
    var star: Int?
    var dateTime: Int64?
    var loveTime: Int?
    var user: UserInfo?
    
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
        return DataManager.instance.star ?? -1
    }
    
    func setHear(heart: Int){
        DataManager.instance.loveTime = heart
    }
    
    func getHeart() -> Int {
        print("================")
        print(DataManager.instance.loveTime)
        return DataManager.instance.loveTime ?? -1
    }
}

