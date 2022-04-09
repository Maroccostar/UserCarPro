//
//  File.swift
//  
//
//  Created by user on 05.04.2022.
//

import Foundation
import Vapor

struct UpdateUserRequest: Content {
    var name: String?
    var username: String?
    var patronymic: String?
}
