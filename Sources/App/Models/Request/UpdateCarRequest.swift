//
//  File.swift
//  
//
//  Created by user on 05.04.2022.
//

import Foundation
import Vapor


struct UpdateCarRequest: Content {
    var name: String?
    var number: Int?
}

extension UpdateCarRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .ascii, required: false)// new valid in name
        validations.add("number", as: Int.self, required: false)// new valid in number
    }
}
