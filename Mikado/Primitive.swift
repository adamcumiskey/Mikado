//
//  Primitive.swift
//  Mikado
//
//  Created by Adam Cumiskey on 12/25/16.
//  Copyright © 2016 adamcumiskey. All rights reserved.
//

import Foundation


protocol Primative {}

extension Int: Primative {}
extension Float: Primative {}
extension Double: Primative {}
extension Bool: Primative {}
extension String: Primative {}
extension Data: Primative {}
extension Date: Primative {}
extension URL: Primative {}
