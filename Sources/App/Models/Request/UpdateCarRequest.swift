//
//  File.swift
//  
//
//  Created by user on 05.04.2022.
//

import Foundation
import Vapor


struct UpdateCarRequest: Content {
    var name: String? // optional
    var number: Int? // optional
}
