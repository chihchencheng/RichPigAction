//
//  NetworkController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/10.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController {
    
    static var networkController: NetworkController?
    
    let MYURL = "http://104.199.188.255:8080/api"
    let AUTH = "/auth"
    let TUTORIAS = "/tutorials"
    
    let defaultSession = URLSession(configuration: .default) //創建一個URLSession,配置用預設->負責發送和接收請求的關鍵物件
    var errorMessage: String = ""
    var dataTask: URLSessionDataTask? //用於發出get請求,取得伺服器資料到本地
//    var session: URLSession?
    
    
    fileprivate init(){}
    
    
    static var getService: NetworkController {
        get{
            if networkController == nil {
                self.networkController = NetworkController()
            }
            return self.networkController!
        }
    }
    
    //用get取得網路連線後結果 //取得所有課程 http://104.199.188.255:8080/api/tutorials
    func requestWithUrl(url: String, completion: @escaping (Data)->Void){
        dataTask?.cancel() //取消任何已存在的dataTask
        let request = URLRequest(url: URL(string: url)!)
        fetchDataByDataTask(from: request, completion: completion)
    }
    
    //get + header(token)
    private func requestWithHeader(url:String, headers:[String:String], completion: @escaping (Data)->Void){
        dataTask?.cancel()
        var request = URLRequest(url: URL(string: url)!)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        fetchDataByDataTask(from: request, completion: completion)
    }
    
    //post
    private func requestWithBody(url: String, body:String, completion: @escaping (Data)->Void){
        dataTask?.cancel()
        var request = URLRequest(url: URL(string: url)!)
        request.httpBody = body.data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchDataByDataTask(from: request, completion: completion)
    }
    
    //post + header(token)
    private func requestWithBodyWithHeader(url: String, headers:[String:String], body:String, completion: @escaping (Data)->Void){
        dataTask?.cancel()
        var request = URLRequest(url: URL(string: url)!)
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        fetchDataByDataTask(from: request, completion: completion)
    }
    
    
    private func fetchDataByDataTask(from request: URLRequest, completion: @escaping (Data)->Void){
        dataTask = defaultSession.dataTask(with: request){ (data, response, error) in
            if error != nil{
                let errorCode = (error! as NSError).code
                if errorCode == -1009 {
                    DispatchQueue.main.async {
//                        self.popAler(withMessage: "No internet connection")
                    }
                    print("No internet connection")
                } else {
                    DispatchQueue.main.async {
//                        self.popAler(withMessage: String(errorCode))
                    }
                    print("Something is wrong")
                }
                return
            }// end of error
            
            else{
                guard let data = data else{return}
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let status = json["status"] as? Int
                    print("狀態:\(status!)")
                    if status != 200 {
                        return
                    }
                    completion(data)
                }catch{
                    print("JSON解析失敗：\(error.localizedDescription)")
                }
                
            }
        }
        dataTask?.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Data)->Void){
        let body = "username=" + username + "&password=" + password
        requestWithBody(url: MYURL + AUTH + "/signin" , body: body, completion: completion)
    }
    
    func register(username: String, email: String, password: String, name: String, completion: @escaping(Data) -> Void){
        let body = "username=" + username + "&email=" + email + "&password=" + password + "&name=" + name
        requestWithBody(url: MYURL + AUTH + "/signup" , body: body, completion: completion)
    }
    
    func updateInfo(level: Int, star: Int, dateTime: Int64, loveTime: Int){
        let level = "level=\(level)"
        let star = "&star=\(star)"
        let dateTime = "&dateTime=\(dateTime)"
        let loveTime = "&loveTime=\(loveTime)"
        let body: String = level+star+dateTime+loveTime
        print(body)
        print("updateInfo")
        useTokenWithPost(url: MyUrl.update.rawValue, body: body) { (json) in
            print(json)
        }
    }
    
    func updateUserInfo(name: String, email: String, completion: @escaping ([String: Any])->Void){ //
        let name = "name=\(name)"
        let email = "&email=\(email)"
        let body: String = name+email
        print(body)
        print("updateUserInfo")
        
        useTokenWithPost(url:MyUrl.updateInfo.rawValue,body:body){ json in
            print(json)
            completion(json)
        }
       
    }

    
    func dowloadImage(url: String, completion: @escaping (UIImage) -> Void){
        
        if let url = URL(string: url){
            let task = defaultSession.downloadTask(with: url, completionHandler: {
                (data, respons, error) in
                // error
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == -1009 {
                        print("no internet connection")
                    }else {
                        print(error!.localizedDescription)
                    }
                    return
                }
                // success
                if let okData = data {
                    do {
                        
                        if let loadedImage = UIImage(data: try Data(contentsOf: okData)){
                           completion(loadedImage)
                        }
                        
                    } catch{
                        print(error.localizedDescription)
                    }
                }
            })
            task.resume()
        }
        
    }//
    
    func getHeadImagebyLevel(completion: @escaping (Data) -> Void ){
        let url = MyUrl.pigCard.rawValue + "/\(DataManager.instance.getLevel())"
        requestWithHeader(url: url, headers: ["Authorization" : DataManager.instance.getToken()], completion: completion)
    
    }
    
    private  func useTokenWithPost(url:String,body:String,completion: @escaping ([String:Any])->Void){
        var request = URLRequest(url:URL(string:url)!)
        request.httpMethod = "POST"
        request.setValue((UserDefaults.standard.object(forKey: "Token") as! String), forHTTPHeaderField: "Authorization")
        
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request){ data,response ,error in
            guard let data = data , error == nil else{
                print("發送失敗！",error?.localizedDescription ?? "data不存在")
                return
            }
            let  json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String : Any])
            completion(json!)
        }
        task.resume()
    }
    
    func getUserInfoWithToken(token: String,callback : @escaping ([String:Any])-> Void ){
        useTokenWithGet(url:MyUrl.userInfo.rawValue){ json in
            guard json["status"] as? Int ?? -1 == 200 else{
                print("抓取資料失敗！")
                return
            }
            
            let okData = json["message"] as? [String:Any]
            DataManager.instance.setHeart(heart: okData?["loveTime"] as? Int ?? -1)
            DataManager.instance.setLevel(level:  okData?["level"] as? Int ?? -1)
            callback(okData ?? ["":""])
            callback(json)
        }
    
    }
    private func useTokenWithGet(url: String,completion: @escaping ([String:Any])->Void){
        var request = URLRequest(url:URL(string:url)!)
        if let token = UserDefaults.standard.object(forKey: "Token") {
            request.httpMethod = "GET"
            request.setValue((token as! String), forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request){ data,response ,error in
                guard let data = data , error == nil else{
                    print("發送失敗！",error?.localizedDescription ?? "data不存在")
                    return
                }
                let  json = try? (JSONSerialization.jsonObject(with: data, options: []) as! [String : Any])
                completion(json!)
            }
            task.resume()
        } else {
            return 
        }
        
    }
    
    func useTokenToGet(url:String ,completion: @escaping (Data) -> Void){
        var request = URLRequest(url:URL(string:url)!)
        if let token = (UserDefaults.standard.object(forKey: "Token")) {
            request.httpMethod = "GET"
            request.setValue((token as! String), forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request){ data,response ,error in
                guard let data = data , error == nil else{
                    print("發送失敗！",error?.localizedDescription ?? "data不存在")
                    return
                }
                let str  = "發送成功" //+ String(data: data,encoding: .utf8)!
                print(str)
                completion(data)
            }
            task.resume()
        } else {
            return
        }
        
    }
    
    
    
    
} // end of class


/*
 //POST http://104.199.188.255:8080/api/auth/update 更新使用者等級、星星、時間
 func updateUserInfo(){
 
 }
 
 
 //GET 取得所有小豬圖鑑(須在header加token) http://104.199.188.255:8080/api/avatars
 func getAllPigPhotos(){
 
 }
 
 //GET 取得小豬圖鑑by level http://104.199.188.255:8080/api/avatars
 func getPigPhotoByLevel(){
 
 }
 
 //GET 取得最愛課程 http://104.199.188.255:8080/api/auth/favorite
 func getFavoriteTutorial(){
 
 }
 
 //POST 加入最愛課程 http://104.199.188.255:8080/api/auth/addToFavorite
 func addFavoriteTutorial(){
 
 }
 
 //POST 移除最愛課程 http://104.199.188.255:8080/api/auth/removeFavorite
 func removeFavoriteTutorial(){
 
 }
 */
