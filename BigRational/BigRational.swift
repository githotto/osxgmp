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
along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/
//
//  BigRational.swift
//  BigNumber
//
//  Created by Otto van Verseveld on 10/26/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

import Foundation

public class BigRational : BigRationalObjC {
    deinit {
//        println("calling deinit of \(self)")
    }
    
    //- GMP Paragraph 6.1 Initialization and Assignment Functions.
    override init() {
        super.init()
    }
}

/*----------------------------------------------------------------------------*\
|  NOTE1: All possible operators are prefixed with BROP_NN (BigRational OPerator),
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
|    The related BROP_NN operators start with the prefixed-comment "//X (BROP_NN)".

|  NOTE3: Based on the Swift standard library operator overview from e.g.
|    http://nshipster.com/swift-operators/ and
|    https://developer.apple.com/library/ios/documentation/swift/conceptual/swift_programming_language/Expressions.html
|         all candidate operators to be implemented for BigRational can be found.
|         The overview is sorted (descending) by precedence value.
\*----------------------------------------------------------------------------*/

//MARK: - Prefix operators
//- (BROP_01) Increment: prefix operator ++
//- (BROP_02) Decrement: prefix operator --
//- (BROP_03) Unary plus: prefix operator +
//- (BROP_04) Unary minus: prefix operator -
//- (BROP_05) Logical NOT: prefix operator !
//- (BROP_06) Bitwise NOT: prefix operator ~


//MARK: - Infix operators
//MARK: -- Exponentiative
//- (BROP_07) Power: infix operator ** { associativity left precedence 160 }
//- (BROP_08) Bitwise left shift: infix operator << { associativity left precedence 160 }
//- (BROP_09) Bitwise right shift: infix operator >> { associativity left precedence 160 }

//MARK: -- Multiplicative
//- (BROP_10) Multiply: infix operator * { associativity left precedence 150 }
//- (BROP_11) Divide: infix operator / { associativity left precedence 150 }
//- (BROP_12) Remainder: infix operator % { associativity left precedence 150 }
//- (BROP_13) Multiply, ignoring overflow: infix operator &* { associativity left precedence 150 }
//- (BROP_14) Divide, ignoring overflow: infix operator &/ { associativity left precedence 150 }
//- (BROP_15) Remainder, ignoring overflow: infix operator &% { associativity left precedence 150 }
//- (BROP_16) Bitwise AND: infix operator & { associativity left precedence 150 }

//MARK: -- Additive
//- (BROP_17) Add: infix operator + { associativity left precedence 140 }
//- (BROP_18) Substract: infix operator - { associativity left precedence 140 }
//- (BROP_19) Add with overflow: infix operator &+ { associativity left precedence 140 }
//- (BROP_20) Substract with overflow: infix operator &- { associativity left precedence 140 }
//- (BROP_21) Bitwise OR: infix operator | { associativity left precedence 140 }
//- (BROP_22) Bitwise XOR: infix operator ^ { associativity left precedence 140 }

//MARK: -- Range
//- (BROP_23) Half-open range: infix operator ..< { associativity none precedence 135 }
//- (BROP_24) Closed range: infix operator ... { associativity none precedence 135 }

//MARK: -- Cast
//X (BROP_25) Type check: infix operator is { associativity none precedence 132 }
//X (BROP_26) Type cast: infix operator as { associativity none precedence 132 }

//MARK: -- Comparative
//- (BROP_27) Less than: infix operator < { associativity none precedence 130 }
//- (BROP_28) Less than or equal: infix operator <= { associativity none precedence 130 }
//- (BROP_29) Greater than: infix operator > { associativity none precedence 130 }
//- (BROP_30) Greater than or equal: infix operator >= { associativity none precedence 130 }
//- (BROP_31) Equal: infix operator == { associativity none precedence 130 }
//- (BROP_32) Not equal: infix operator != { associativity none precedence 130 }
//- (BROP_33) Identical: infix operator === { associativity none precedence 130 }
//- (BROP_34) Not identical: infix operator !== { associativity none precedence 130 }
//- (BROP_35) Pattern match: infix operator ~= { associativity none precedence 130 }

//MARK: -- Conjunctive
//- (BROP_36) Logical AND: infix operator && { associativity left precedence 120 }

//MARK: -- Disjunctive
//- (BROP_37) Logical OR: infix operator || { associativity left precedence 110 }

//MARK: -- Nil Coalescing
//X (BROP_38) Nil coalescing: infix operator ?? { associativity right precedence 110 }

//MARK: -- Ternary Conditional
//X (BROP_39) Ternary conditional: infix operator ?: { associativity right precedence 100 }

//MARK: -- Assignment
//X (BROP_40) Assign: infix operator = { associativity right precedence 90 }
//- (BROP_41) Multiply and assign: infix operator *= { associativity right precedence 90 }
//- (BROP_42) Divide and assign: infix operator /= { associativity right precedence 90 }
//- (BROP_43) Remainder and assign: infix operator %= { associativity right precedence 90 }
//- (BROP_44) Add and assign: infix operator += { associativity right precedence 90 }
//- (BROP_45) Substract and assign: infix operator -= { associativity right precedence 90 }
//- (BROP_46) Power and assign: infix operator **= { associativity right precedence 90 }
//- (BROP_47) Left bit shift and assign: infix operator <<= { associativity right precedence 90 }
//- (BROP_48) Right bit shift and assign: infix operator >>= { associativity right precedence 90 }
//- (BROP_49) Bitwise AND and assign: infix operator &= { associativity right precedence 90 }
//- (BROP_50) Bitwise XOR and assign: infix operator ^= { associativity right precedence 90 }
//- (BROP_51) Bitwise OR and assign: infix operator |= { associativity right precedence 90 }
//- (BROP_52) Logical AND and assign: infix operator &&= { associativity right precedence 90 }
//- (BROP_53) Logical OR and assign: infix operator ||= { associativity right precedence 90 }


//MARK: - Postfix operators
//- (BROP_54) Increment: postfix operator ++
//- (BROP_55) Decrement: postfix operator --
