//
//  File.swift
//  
//
//  Created by user on 04.04.2022.
//

import Foundation
import Vapor


struct CreateCarRequest: Content {
    var name: String?
    var number: Int?
}
