//
//  File.swift
//  
//
//  Created by user on 17.04.2022.
//
import Foundation
import Vapor


struct WheelsResponse: Content {
    var id: UUID?
    var frontLeft: String?
    var frontRight: String?
    var rearLeft: String?
    var rearRight: String?
    

    init(wheel: Wheels) {
        self.id = wheel.id
        self.frontLeft = wheel.frontLeft
        self.frontRight = wheel.frontRight
        self.rearLeft = wheel.rearLeft
        self.rearRight = wheel.rearRight
       
    }
    
}

