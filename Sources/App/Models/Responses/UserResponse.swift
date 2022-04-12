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
  
    init(user: User) {
        self.id = user.id
        self.name = user.name
        self.username = user.username
        self.patronymic = user.patronymic
    }
}
