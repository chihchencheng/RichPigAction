//
//  File.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/11.
//  Copyright © 2020 cheng. All rights reserved.
//

import Foundation

enum MyUrl: String {
    case login = "http://104.199.188.255:8080/api/auth/signin"
    case register = "http://104.199.188.255:8080/api/auth/signup"
    case tutorials = "http://104.199.188.255:8080/api/tutorials"
    case pigCard = "http://104.199.188.255:8080/api/avatars"
    case userInfo = "http://104.199.188.255:8080/api/auth/userInfo"
    case favorite = "http://104.199.188.255:8080/api/auth/favorite"
    case update = "http://104.199.188.255:8080/api/auth/update"
    case updateInfo = "http://104.199.188.255:8080/api/auth/updateInfo"
}
