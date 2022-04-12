//
//  File.swift
//  
//
//  Created by user on 04.04.2022.
//

import Foundation
import Vapor


struct CreateCarRequest: Content {
    var name: String?
    var number: Int?
}

extension CreateCarRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: .ascii, required: true)// new valid in name
        validations.add("number", as: Int.self, required: true)// new valid in number
    }
}
