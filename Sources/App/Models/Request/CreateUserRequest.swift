//
//  File.swift
//  
//
//  Created by user on 04.04.2022.
//

import Foundation
import Vapor

struct CreateUserRequest: Content {
    var name: String?
    var username: String?
    var patronymic: String?
}

extension CreateUserRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .ascii, required: true)// new valid in name
        validations.add("username", as: String.self, is: .ascii, required: true)// new valid in number
        validations.add("patronymic", as: String.self, is: .ascii, required: true)// new valid in name
    }
    
}
