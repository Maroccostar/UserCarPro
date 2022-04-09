//
//  File.swift
//  
//
//  Created by user on 09.04.2022.
//

import Vapor

/// Body for error response
struct ErrorResponse: Content {
    
    /// Some Error in `String` type.
    var error: Bool?
    
    /// Some Error in `String` type.
    var reason: String
    
    /// Some Error in `String` type.
    var errorCode: String?
}
