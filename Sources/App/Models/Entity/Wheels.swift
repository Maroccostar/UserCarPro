//
//  File.swift
//  
//
//  Created by user on 17.04.2022.
//

import Fluent
import Vapor

final class Wheels: Model, Content {
    
    static let schema = "wheels"
    
    @ID
    var id: UUID?
    
    @Field(key: "frontLeft")
    var frontLeft: String

    @Field(key: "frontRight")
    var frontRight: String

    @Field(key: "rearLeft")
    var rearLeft: String

    @Field(key: "rearRight")
    var rearRight: String
    
    @Parent(key: "car_id")
    var car: Car
    
    
    init() {}
    
    init(id: UUID? = nil, frontLeft: String, frontRight: String, rearLeft: String, rearRight: String) {
        self.id = id
        self.frontLeft = frontLeft
        self.frontRight = frontRight
        self.rearLeft = rearLeft
        self.rearRight = rearRight
    }
    
}
