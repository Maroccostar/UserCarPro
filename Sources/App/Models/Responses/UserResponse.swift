//
//  File.swift
//  
//
//  Created by user on 10.04.2022.
//

import Foundation
import Vapor


struct UserResponse: Content {
    var id: UUID?
    var name: String?
    var username: String?
    var patronymic: String?
    //    var create_at: String?
    //    var update_at: String?
    //    var delete_at: String?
    
    
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.patronymic = user.patronymic
        //        self.create_at = user.create_at
        //        self.update_at = user.update_at
        //        self.delete_at = user.delete_at // camel case
    }

}
