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
    

    init(car: Car) {
        self.id = car.id
        self.name = car.name
        self.number = car.number
       
    }
    
}

