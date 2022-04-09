//
//  File.swift
//  
//
//  Created by user on 04.04.2022.
//

import Foundation // для UUID
import Vapor // 

struct CreateUserRequest: Content {
    var name: String?
    var username: String?
    var patronymic: String?
}

