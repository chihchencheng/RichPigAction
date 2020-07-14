//
//  Models.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/10.
//  Copyright © 2020 cheng. All rights reserved.
//




// for login message
struct LoginInfo: Decodable {
    var status: Int?
    var message: UserInfo?
}

struct UserInfo: Decodable {
    var level: Int?
    var star: Int?
    var dateTime: Int?
    var loveTime: Int?
    var accessToken: String?
    var tokenType: String?
    var username: String?
}

class UpdateLevelInfo {
    var level: Int?
    var star: Int?
    var dateTime: Int64?
    var loveTime: Int?
} 


// for register message
struct RegisterMsg: Decodable {
    var status: Int?
    var message: RegInfo?
}

struct RegInfo: Decodable {
    var username: String?
    var level: String?
    var star: String?
    var dateTime: Int?
    var loveTime: Int?
}

struct AllData: Decodable{
    var message: [SingleData]?
}

struct SingleSetData: Decodable {
    var message: SingleData?
}

struct SingleData: Decodable {
    var id: Int?
    var level: Int?
    var title: String?
    var url: String?
    var type: Int?
    var quizzes: [Quiz]?
    var courses: [Course]?
}

struct Quiz: Decodable {
    var id: Int?
    var level: Int?
    var type: Int?
    var category: String?
    var question: String?
    var options: String?
    var ans: Int?
}

struct Course: Decodable {
    var id: Int?
    var level: Int?
    var desc: String?
    var url: String?
}

struct QuestionSet {
    var category: String?
    var question: String?
    var options: [String]?
    var answer: Int?
    
}

// 下載豬圖庫
struct PigData: Decodable {
    var message: Avatars?
}

struct Avatars: Decodable {
    var avatars: [Piggy]?
}

struct Piggy: Decodable {
    var id: Int?
    var level: Int?
    var desc: String?
    var url: String?
    var title: String?
    var trait: String?
    var expect: String?
}
