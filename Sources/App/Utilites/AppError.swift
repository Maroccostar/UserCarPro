//
//  File.swift
//  
//
//  Created by user on 09.04.2022.
//

import Vapor

protocol AppError: AbortError, DebuggableError { }
