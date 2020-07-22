//
//  File.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation

var baseURL = "http://104.199.188.255:8080/api"
enum MyUrl: String {
    case login = "http://104.199.188.255:8080/api/auth/signin"
    case register = "http://104.199.188.255:8080/api/auth/signup"
    case tutorials = "http://104.199.188.255:8080/api/tutorials"
    case pigCard = "http://104.199.188.255:8080/api/avatars"
    case userInfo = "http://104.199.188.255:8080/api/auth/userInfo"
    case update = "http://104.199.188.255:8080/api/auth/update"
    case updateInfo = "http://104.199.188.255:8080/api/auth/updateInfo"
    case addFavorite = "http://104.199.188.255:8080/api/auth/addToFavorite"
    case removeFavorite = "http://104.199.188.255:8080/api/auth/removeFavorite"
    case getFavorite = "http://104.199.188.255:8080/api/auth/favorite"
    case sendEmail = "http://104.199.188.255:8080/sendMail/"
    case resetPassword = "http://104.199.188.255:8080/api/auth/resetPass"
}
