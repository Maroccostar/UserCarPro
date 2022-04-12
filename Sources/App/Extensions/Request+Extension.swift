//
//  File.swift
//  
//
//  Created by user on 11.04.2022.
//

import Foundation
import Vapor

extension Request {
    var userService: UsersService {
        .init(req:self)
    }
}
