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
    var level = 0
    var star: Int?
    var dateTime: Int64?
    var loveTime: Int?
    var user: UserInfo?
    var image: UIImage?
    var username = ""
    var email = ""
    var name = ""
    var account = ""
    var favoriteCourse = [Int]()
    var userImage = UIImage()
    var loginTime: Int64 = 0
    var collection = [UIImage]()
    var courseIndex = 0
    var allCourseArr = [[Course]]()
    
    
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
        return DataManager.instance.loveTime ?? 0
    }
    
    func setLevel(level: Int) {
        DataManager.instance.level = level
    }
    
    func getLevel() -> Int {
        return DataManager.instance.level
    }
    
    func setHeadImage(image: UIImage){
        self.userImage = image
    }
    
    func getHeadImage() -> UIImage {
        return self.userImage
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
    }
    
    func addFavoriteCourse(courseIndex: Int){
        self.favoriteCourse.append(courseIndex)
    }
    
    func getFavoriteCourses() -> [Int]{
        return self.favoriteCourse
    }
    
    func setupLoginTime(time: Int64){
        DataManager.instance.loginTime = time
    }
    func getLoginTime() -> Int64 {
        return DataManager.instance.loginTime
    }
    
    func gainHeart(){
        guard let currentTime = Date().toMillis() else { return }
        if currentTime - DataManager.instance.getLoginTime() == 300000 {//300000
            DataManager.instance.setHeart(heart: DataManager.instance.getHeart()+1)
            DataManager.instance.setupLoginTime(time: Date().toMillis())
        }
    }
    
    func setCollection(collection: [UIImage]){
        DataManager.instance.collection = collection
    }
    
    func getUserInfo() -> String {
        return DataManager.instance.username
    }
    func setUserName(username: String) {
        DataManager.instance.username = username
    }
    
    func getUserName() -> String {
        return DataManager.instance.username
    }
    
    func getName() -> String{
        return DataManager.instance.name
    }
    
    func setName(name: String) {
        DataManager.instance.name = name
    }
    
    func getEmail() -> String {
        return DataManager.instance.email
    }
    func setEmail(email: String){
        DataManager.instance.email = email
    }
    
    func getCourseIndex() -> Int{
        return DataManager.instance.courseIndex
    }
    
    func setCourseIndex(index: Int) {
        DataManager.instance.courseIndex = index
    }
    func setAllCourseArr(allCourseArr: [[Course]]){
        DataManager.instance.allCourseArr = allCourseArr
    }
    func getAllCourseArr() -> [[Course]]{
        DataManager.instance.getAllCourseArr()
    }
    
}


