//
//  File.swift
//  
//
//  Created by user on 10.04.2022.
//

import Foundation
import Vapor
import Fluent

struct UsersService {
    let req: Request
    
    func getUser(userID: UUID) -> EventLoopFuture<User> {
        return User.query(on: req.db(.psql))// new CarController CreateCarRequest
            .filter(\.$id == userID)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { user in
                return user
            }
    }
}
