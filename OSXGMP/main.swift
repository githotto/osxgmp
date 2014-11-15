//
//  main.swift
//  OSXGMP
//
//  Created by Otto van Verseveld on 11/14/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

import Foundation

println("Hello, OSXGMP / BigInt World!\n")

var err : NSError?
var bi1 = BigInt(nr: 12468642135797531)
var bi2 = BigInt(nr: "12345678901011121314151617181920", error: &err)
var res = bi1 * bi2
println("Multiply 2 BigInts: bi1 * bi2 = \(res.toString())")
