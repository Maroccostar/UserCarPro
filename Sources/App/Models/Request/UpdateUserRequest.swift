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

extension UpdateUserRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .ascii, required: false)// new valid in name
        validations.add("username", as: String.self, is: .ascii, required: false)// new valid in number
        validations.add("patronymic", as: String.self, is: .ascii, required: false)// new valid in name
    }
    
}
