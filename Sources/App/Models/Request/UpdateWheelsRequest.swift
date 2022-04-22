//
//  File.swift
//  
//
//  Created by user on 17.04.2022.
//

import Foundation
import Vapor


struct UpdateWheelsRequest: Content {
    var frontLeft: String?
    var frontRight: String?
    var rearLeft: String?
    var rearRight: String?
}

extension UpdateWheelsRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("frontLeft", as: String.self, is: .ascii, required: true)// new valid in name
        validations.add("frontRight", as: String.self, is: .ascii, required: true)// new valid in name
        validations.add("rearLeft", as: String.self, is: .ascii, required: true)// new valid in name
        validations.add("rearRight", as: String.self, is: .ascii, required: true)// new valid in name
    }
}


