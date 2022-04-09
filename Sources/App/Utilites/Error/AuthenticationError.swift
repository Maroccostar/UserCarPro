//
//  File.swift
//  
//
//  Created by user on 09.04.2022.
//

import Vapor

enum AuthenticationError: AppError {
    
    case missingAuthorizationHeader

}

extension AuthenticationError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
            
        case .missingAuthorizationHeader:
            return .unauthorized
            
        }
    }
    
    var reason: String {
        switch self {
       
        case .missingAuthorizationHeader:
            return "Missing authorization header"
            
        }
    }
    
    var identifier: String {
        switch self {
        
        case .missingAuthorizationHeader:
            return "missing_authorization_header"

        }
    }
}
