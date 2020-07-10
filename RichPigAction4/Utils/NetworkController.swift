//
//  NetworkController.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/10.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation

class NetworkController {
    
    let MYURL = "http://104.199.188.255:8080/api"
    let AUTH = "/auth"
    let TUTORIAS = "/tutorials"
    let TOKEN = "x-access-token"
    
    let defaultSession = URLSession(configuration: .default) //創建一個URLSession,配置用預設->負責發送和接收請求的關鍵物件
    var errorMessage: String = ""
    var dataTask: URLSessionDataTask? //用於發出get請求,取得伺服器資料到本地
    
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
                print("fechDataByDataTask is not nil -> error")
            }else{
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
    
    func getPigPicture(){
        
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
