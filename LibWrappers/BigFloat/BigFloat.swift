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
//  BigFloat.swift
//  BigNumber
//
//  Created by Otto van Verseveld on 10/26/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

import Foundation

public class BigFloat : BigFloatObjC {
    deinit {
//        println("calling deinit of \(self)")
    }
    
    //- GMP Paragraph 7.1 Initialization Functions.
    override init() {
        super.init()
    }
}

/*----------------------------------------------------------------------------*\
|  NOTE1: All possible operators are prefixed with BFOP_NN (BigFloat OPerator),
|         where NN=1,...,55
|
|  NOTE2: From e.g.
|    https://medium.com/swift-programming/facets-of-swift-part-5-custom-operators-1080bc78ccc
|    we learn that we can NOT overload the following:
|    // ternary-operator:
|      ? :
|    // infix-operators:
|      = is as as? ??
|    // prefix-operator:
|      &
|    // postfix-operator:
|      ? !
|    The related BFOP_NN operators start with the prefixed-comment "//X (BFOP_NN)".

|  NOTE3: Based on the Swift standard library operator overview from e.g.
|    http://nshipster.com/swift-operators/ and
|    https://developer.apple.com/library/ios/documentation/swift/conceptual/swift_programming_language/Expressions.html
|         all candidate operators to be implemented for BigFloat can be found.
|         The overview is sorted (descending) by precedence value.
\*----------------------------------------------------------------------------*/

//MARK: - Prefix operators
//- (BFOP_01) Increment: prefix operator ++
//- (BFOP_02) Decrement: prefix operator --
//- (BFOP_03) Unary plus: prefix operator +
//- (BFOP_04) Unary minus: prefix operator -
//- (BFOP_05) Logical NOT: prefix operator !
//- (BFOP_06) Bitwise NOT: prefix operator ~


//MARK: - Infix operators
//MARK: -- Exponentiative
//- (BFOP_07) Power: infix operator ** { associativity left precedence 160 }
//- (BFOP_08) Bitwise left shift: infix operator << { associativity left precedence 160 }
//- (BFOP_09) Bitwise right shift: infix operator >> { associativity left precedence 160 }

//MARK: -- Multiplicative
//- (BFOP_10) Multiply: infix operator * { associativity left precedence 150 }
//- (BFOP_11) Divide: infix operator / { associativity left precedence 150 }
//- (BFOP_12) Remainder: infix operator % { associativity left precedence 150 }
//- (BFOP_13) Multiply, ignoring overflow: infix operator &* { associativity left precedence 150 }
//- (BFOP_14) Divide, ignoring overflow: infix operator &/ { associativity left precedence 150 }
//- (BFOP_15) Remainder, ignoring overflow: infix operator &% { associativity left precedence 150 }
//- (BFOP_16) Bitwise AND: infix operator & { associativity left precedence 150 }

//MARK: -- Additive
//- (BFOP_17) Add: infix operator + { associativity left precedence 140 }
//- (BFOP_18) Substract: infix operator - { associativity left precedence 140 }
//- (BFOP_19) Add with overflow: infix operator &+ { associativity left precedence 140 }
//- (BFOP_20) Substract with overflow: infix operator &- { associativity left precedence 140 }
//- (BFOP_21) Bitwise OR: infix operator | { associativity left precedence 140 }
//- (BFOP_22) Bitwise XOR: infix operator ^ { associativity left precedence 140 }

//MARK: -- Range
//- (BFOP_23) Half-open range: infix operator ..< { associativity none precedence 135 }
//- (BFOP_24) Closed range: infix operator ... { associativity none precedence 135 }

//MARK: -- Cast
//X (BFOP_25) Type check: infix operator is { associativity none precedence 132 }
//X (BFOP_26) Type cast: infix operator as { associativity none precedence 132 }

//MARK: -- Comparative
//- (BFOP_27) Less than: infix operator < { associativity none precedence 130 }
//- (BFOP_28) Less than or equal: infix operator <= { associativity none precedence 130 }
//- (BFOP_29) Greater than: infix operator > { associativity none precedence 130 }
//- (BFOP_30) Greater than or equal: infix operator >= { associativity none precedence 130 }
//- (BFOP_31) Equal: infix operator == { associativity none precedence 130 }
//- (BFOP_32) Not equal: infix operator != { associativity none precedence 130 }
//- (BFOP_33) Identical: infix operator === { associativity none precedence 130 }
//- (BFOP_34) Not identical: infix operator !== { associativity none precedence 130 }
//- (BFOP_35) Pattern match: infix operator ~= { associativity none precedence 130 }

//MARK: -- Conjunctive
//- (BFOP_36) Logical AND: infix operator && { associativity left precedence 120 }

//MARK: -- Disjunctive
//- (BFOP_37) Logical OR: infix operator || { associativity left precedence 110 }

//MARK: -- Nil Coalescing
//X (BFOP_38) Nil coalescing: infix operator ?? { associativity right precedence 110 }

//MARK: -- Ternary Conditional
//X (BFOP_39) Ternary conditional: infix operator ?: { associativity right precedence 100 }

//MARK: -- Assignment
//X (BFOP_40) Assign: infix operator = { associativity right precedence 90 }
//- (BFOP_41) Multiply and assign: infix operator *= { associativity right precedence 90 }
//- (BFOP_42) Divide and assign: infix operator /= { associativity right precedence 90 }
//- (BFOP_43) Remainder and assign: infix operator %= { associativity right precedence 90 }
//- (BFOP_44) Add and assign: infix operator += { associativity right precedence 90 }
//- (BFOP_45) Substract and assign: infix operator -= { associativity right precedence 90 }
//- (BFOP_46) Power and assign: infix operator **= { associativity right precedence 90 }
//- (BFOP_47) Left bit shift and assign: infix operator <<= { associativity right precedence 90 }
//- (BFOP_48) Right bit shift and assign: infix operator >>= { associativity right precedence 90 }
//- (BFOP_49) Bitwise AND and assign: infix operator &= { associativity right precedence 90 }
//- (BFOP_50) Bitwise XOR and assign: infix operator ^= { associativity right precedence 90 }
//- (BFOP_51) Bitwise OR and assign: infix operator |= { associativity right precedence 90 }
//- (BFOP_52) Logical AND and assign: infix operator &&= { associativity right precedence 90 }
//- (BFOP_53) Logical OR and assign: infix operator ||= { associativity right precedence 90 }


//MARK: - Postfix operators
//- (BFOP_54) Increment: postfix operator ++
//- (BFOP_55) Decrement: postfix operator --
