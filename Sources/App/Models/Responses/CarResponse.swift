//
//  File.swift
//  
//
//  Created by user on 11.04.2022.
//

import Foundation
import Vapor


struct CarResponse: Content {
    var id: UUID?
    var name: String?
    var number: Int?
    
//    init(id: UUID? = nil, name: String? = nil, number: Int? = nil) { //CarController
//        self.id = id
//        self.name = name
//        self.number = number
//    }
    
    init(car: Car) {
        self.id = car.id
        self.name = car.name
        self.number = car.number
       
    }
    
}

//struct CarResponse2: Content {// CarController
//    var id: UUID?
//    var name: String?
//    var number: Int?
//
//    init(id: UUID? = nil, name: String? = nil, number: Int? = nil) {
//        self.id = id
//        self.name = name
//        self.number = number
//    }
//}
