/*
This file is part of OSXGMP.

OSXGMP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

OSXGMP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with OSXGMP.  If not, see <http://www.gnu.org/licenses/>.
*/
//
//  main.swift
//  OSXGMP
//
//  Created by Otto van Verseveld on 11/14/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

import Foundation

print("Hello (Swift3.0/Xcode8.2), OSXGMP / BigInt World!\n")

var bi1 = BigInt(intNr: 12468642135797531)
do {
    var bi2 = try BigInt(stringNr: "12345678901011121314151617181920")
    var res = bi1 * bi2
    print("Multiply 2 BigInts: bi1 * bi2 = \(res.toString())")
} catch BigIntError.emptyStringNumber {
    print("EmptyStringNumber for bi2")
} catch BigIntError.invalidBaseNumber {
    print("InvalidBaseNumber for bi2")
} catch BigIntError.invalidNumberFormat {
    print("InvalidNumberFormat for bi2")
}
