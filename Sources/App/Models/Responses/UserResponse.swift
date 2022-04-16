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
//    var create_add: String?
//    var update_add: String?
//    var delete_add: String?
    
  
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.patronymic = user.patronymic
//        self.create_add = user.create_add
//        self.update_add = user.update_add
//        self.delete_add = user.delete_add
}
