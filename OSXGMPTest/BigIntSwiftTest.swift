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
//  BigIntSwiftTest.swift
//  OSXGMP
//
//  Created by Otto van Verseveld on 11/15/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

import Cocoa
import Foundation
import XCTest

class BigIntSwiftTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - GMP 5.1 Initialization Functions ---------------------------------
    func test05_01_Initialization() {
        // Test default initializer.
        var bi = BigInt()
        var result = (bi.toString() == "0")
        XCTAssert(result, "Init() should set value to 0!")
        
        // Test default string-initializer.
        var err : NSError?
        bi = BigInt(nr: "", error: &err)
        //- Get returned error-code.
        var errCode = err?.code
        //- Get expected error-code. Note: add (Int)-cast since value is UInt32.
        var expCode = (Int)(BIEC_EmptyStringNumber.value)
        //- Check if we've an error, the appropriate code and initalized value.
        result = (err != nil) && (errCode! == expCode) && (bi.toString() == "0")
        //        println("X. result=\(result), errCode=\(errCode!), expCode=\(expCode)")
        XCTAssert(result, "Init(String) should fail with errCode=EmptyStringNumber and have default value of 0!")
        
        // Test for error in string-initializer with invalid base-number.
        bi = BigInt(nr: "101", base: 63, error: &err)
        errCode = err?.code
        expCode = (Int)(BIEC_InvalidBaseNumber.value)
        result = (err != nil) && (errCode! == expCode)
        XCTAssert(result, "Init(String,base) should fail with errCode=InvalidBaseNumber and have default value of 0!")
        
        // Test for error in string-initializer with invalid number for base.
        bi = BigInt(nr: "12", base: 2, error: &err)
        errCode = err?.code
        expCode = (Int)(BIEC_InvalidNumberFormat.value)
        result = (err != nil) && (errCode! == expCode) && (bi.toString() == "0")
        XCTAssert(result, "Init(String,base) should fail with errCode=InvalidNumberFormat and have default value of 0!")
        
        // Test for no-error in string-initializer with valid number for base.
        bi = BigInt(nr: "12", base: 3, error: &err)
        result = (err == nil)
        XCTAssert(result, "Init(String,base) should NOT fail with: err=\(err?.code)")
    }
    
    //MARK: - GMP 5.2 Assignment Functions -------------------------------------
    func test05_02_Assignment() {
        // Test string-initializer with invalid number for base.
        var err : NSError?
        var bi = BigInt(nr: "12", base: 2, error: &err)
        var result = (bi.toString() == "0")
        XCTAssert(result, "BigInt should be initialized to default value: 0")
        
        // Test string-initializer with valid number for base.
        bi = BigInt(nr: "12", base: 3, error: &err)
        result = (bi.toString() == "5")
        XCTAssert(result, "BigInt should be initialized to value: 5")
        
        // Test value of large number string-initializer.
        bi = BigInt(nr: "1234567890987654321", error: &err)
        result = (bi.toString() == "1234567890987654321")
        XCTAssert(result, "BigInt should be initialized to value: 1234567890987654321")
        
        // Test swapping two variables using instance and method.
        bi = BigInt(nr: 11)
        var biSwap = BigInt(nr: 2222)
        bi.swap(biSwap)
        result = ((bi.toString() == "2222") && (biSwap.toString() == "11"))
        XCTAssert(result, "Swapping bi,biSwap should result in '2222' and '11' !")
        
        // Test swapping two variables using Class method.
        BigInt.swap(bi, bn2: biSwap)
        result = ((bi.toString() == "11") && (biSwap.toString() == "2222"))
        XCTAssert(result, "Swapping bi,biSwap should result in '11' and '2222' !")
    }
    
    func test05_02_Assignment_Operators() {
        var bi1 = BigInt(nr: 11110000)
        var bi2 = BigInt(nr: 00002200)
        var nrLong : Int = -2
        var nrULong : UInt = 24
        
        // Test += (BIOP_41) operator with:
        //-- type BigInt
        bi1 += bi2
        var result = (bi1.toString() == "11112200")
        XCTAssert(result, "bi1 += bi2 should equal '11112200' !")
        //-- type ULong
        bi1 += nrULong
        result = (bi1.toString() == "11112224")
        XCTAssert(result, "bi1 += 24 should equal '11112224' !")
        //-- type Long
        bi1 += nrLong
        result = (bi1.toString() == "11112222")
        XCTAssert(result, "bi1 += 24 should equal '11112224' !")
        
        //TODO: should test assignment operators: /= (BIOP_42) ... ||= (BIOP_53)
        //...
    }
    
    //MARK: - GMP 5.3 Combined Initialization and Assignment Functions ---------
    func test05_03_CombinedInitializationAndAssignment() {
        // Test initializer-BigInt.
        var bi = BigInt(nr: BigInt(nr: 2))
        var result = (bi.toString() == "2")
        XCTAssert(result, "Overloaded Initializer-BigInt should be 2!")
        
        // Test initializer-Double.
        bi = BigInt(nr: 2.9)
        result = (bi.toString() == "2")
        XCTAssert(result, "Overloaded Initializer-Double(2.9) should truncate to 2!")
        bi = BigInt(nr: 3.0)
        result = (bi.toString() == "3")
        XCTAssert(result, "Overloaded Initializer-Double(3.0) should be equal to 3!")
        bi = BigInt(nr: 3.1)
        result = (bi.toString() == "3")
        XCTAssert(result, "Overloaded Initializer-Double(3.1) should truncate to 3!")
    }
    
    //MARK: - GMP 5.4 Conversion Functions -------------------------------------
    func test05_04_Conversion() {
        var err : NSError?
        var bi = BigInt(nr: "9", error: &err) // NOTE: uses default base=10 here.
        
        // NOTE1: No check needed since Swift automatically assigns the correct type.
        var biDouble = bi.toDouble()
        var biLong = bi.toSLong()    // Long 'translates' to Swifts Int type.
        var biULong = bi.toULong()  // ULong 'translates' to Swifts UInt type.
        // TODO: Should we test for over/under-flow here?!
        
        // Test conversion to base 10 (=default one).
        var biString = bi.toString()
        var result = (biString == "9")
        XCTAssert(result, "BigInt.toString() should equal 9 for base=10 !")
        
        // Test conversion to base 2.
        biString = bi.toStringInBase(2)
        result = (biString == "1001")
        XCTAssert(result, "BigInt.toString(2) should equal 1001 for base=2 !")
    }
    
    //MARK: - GMP 5.5 Arithmetic Functions -------------------------------------
    func test05_05_Arithmetic_Add() {
        var bi1 = BigInt(nr: 222_000_000)
        var bi2 = BigInt(nr: 000_111_000)
        var nrLong : Int = -111_000_000
        var nrULong : UInt = 111_000
        
        // Testing add for the GMP functions:
        //-- mpz_add
        var bi3 = BigInt.add(bi1, op2: bi2)
        var result = (bi3.toString() == "222111000")
        //        println("X. bi3=\(bi3.toString()), result=\(result)")
        XCTAssert(result, "Add(bi1,bi2) should equal 222111000.")
        //-- mpz_add_ui
        bi3.addULong(111_000)
        result = (bi3.toString() == "222222000")
        XCTAssert(result, "Add(bi1,ULong) should equal 222222000.")
        //-- mpz_add_si. NOTE: not in GMP, but added for convenience.
        bi3.addSLong(-11_000)
        result = (bi3.toString() == "222211000")
        XCTAssert(result, "Add(bi1,Long) should equal 222211000.")
    }
    
    func test05_05_Arithmetic_Add_Operators() {
        var bi1 = BigInt(nr: 222_000_000)
        var bi2 = BigInt(nr: 000_111_000)
        var nrLong : Int = -111_000_000
        var nrULong : UInt = 111_000
        
        // Test + (BIOP_17) operator with:
        //-- type BigInt and BigInt
        var bi3 = bi1 + bi2
        var result = (bi3.toString() == "222111000")
        XCTAssert(result, "bi1 + bi2 should equal 222111000.")
        //-- type BigInt and Long
        bi3 = bi1 + nrLong
        result = (bi3.toString() == "111000000")
        XCTAssert(result, "bi1 + ULong should equal 111000000.")
        //-- type BigInt and ULong
        bi3 = bi1 + nrULong
        result = (bi3.toString() == "222111000")
        XCTAssert(result, "bi1 + ULong should equal 222111000.")
        //-- type Long and BigInt
        bi3 = nrLong + bi1
        result = (bi3.toString() == "111000000")
        XCTAssert(result, "Long + bi1 should equal 111000000.")
        //-- type ULong and BigInt
        bi3 = nrULong + bi1
        result = (bi3.toString() == "222111000")
        XCTAssert(result, "Long + bi1 should equal 222111000.")
        
//        //TODO: overflow &+ (BIOP_19) operator with e.g. Int.max, Int.min
//        println("Int.min=\(Int.min), Int.max=\(Int.max), UInt.min=\(UInt.min), UInt.max=\(UInt.max)")
//        var bi4 = BigInt(nr: 0)
//        bi3 = bi4 - Int.min
//        var maxLong = bi3.toLong() //NOTE: should result in an overflow!
//        println("X. bi3=\(bi3.toString()), result=\(result), maxLong=\(maxLong)")
    }
    
    func test05_05_Arithmetic_Substract() {
        var bi1 = BigInt(nr: 222_000_000)
        var bi2 = BigInt(nr: 000_111_000)
        var nrLong : Int = -111_000_000
        var nrULong : UInt = 111_000
        
        // Testing substract for the GMP functions:
        //-- mpz_sub
        var bi3 = BigInt.sub(bi1, op2: bi2)
        var result = (bi3.toString() == "221889000")
        XCTAssert(result, "Sub(bi1,bi2) should equal 221889000.")
        //-- mpz_sub_ui
        bi3.subULong(nrULong)
        result = (bi3.toString() == "221778000")
        XCTAssert(result, "Sub(bi3,ULong) should equal 221778000.")
        //-- mpz_sub_si. NOTE: not in GMP, but added for convenience.
        bi3.subSLong(nrLong)
        result = (bi3.toString() == "332778000")
        XCTAssert(result, "Sub(bi3,ULong) should equal 332778000.")
        //-- mpz_ui_sub is NOT implemented/tested!
    }
    
    func test05_05_Arithmetic_Substract_Operators() {
        var bi1 = BigInt(nr: 222_000_000)
        var bi2 = BigInt(nr: 000_111_000)
        var nrLong : Int = -111_000_000
        var nrULong : UInt = 111_000
        
        // Test - (BIOP_18) operator with:
        //-- type BigInt and BigInt
        var bi3 = bi1 - bi2
        var result = (bi3.toString() == "221889000")
        XCTAssert(result, "bi1 - bi2 should equal 221889000.")
        //-- type BigInt and Long
        bi3 = bi1 - 2_123_457
        result = (bi3.toString() == "219876543")
        XCTAssert(result, "bi1 - Long should equal 219876543.")
        //-- type BigInt and ULong
        bi3 = bi1 - nrULong
        result = (bi3.toString() == "221889000")
        XCTAssert(result, "Long - bi1 should equal 221889000.")
        //-- type Long and BigInt
        bi3 = nrLong - bi1
        result = (bi3.toString() == "-333000000")
        XCTAssert(result, "Long - bi1 should equal -333000000.")
        //-- type ULong and BigInt
        bi3 = nrULong - bi1
        result = (bi3.toString() == "-221889000")
        XCTAssert(result, "Long - bi1 should equal -221889000.")
    }
    
    func test05_05_Arithmetic_Multiply() {
        var bi1 = BigInt(nr: 111_000)
        var bi2 = BigInt(nr: 000_222)
        var nrLong : Int = -333_000
        var nrULong : UInt = 000_444
        
        // Testing multiply for the GMP functions:
        //-- mpz_mul (with type BigInt and BigInt)
        var bi3 = BigInt.mul(bi1, op2: bi2)
        var result = (bi3.toString() == "24642000")
        XCTAssert(result, "Mul(bi1,bi2) should equal 24642000.")
        //-- mpz_mul_si (with type BigInt and Long)
        bi3 = BigInt.mulSLong(bi1, op2: nrLong)
        result = (bi3.toString() == "-36963000000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal -36963000000.")
        //-- mpz_mul_ui (with type BigInt and ULong)
        bi3 = BigInt.mulULong(bi1, op2: nrULong)
        result = (bi3.toString() == "49284000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal 49284000.")
        
        // Testing GMP functions:
        //-- mpz_addmul (with type BigInt and BigInt)
        bi3 = BigInt(nr: 000_333)
        bi3.addMul(bi1, op2: bi2)
        result = (bi3.toString() == "24642333")
        XCTAssert(result, "addMul(bi1,bi2) should equal 24642333.")
        //-- mpz_addmul_ui (with type BigInt and ULong)
        bi3.addMulULong(bi1, op2: nrULong)
        result = (bi3.toString() == "73926333")
        XCTAssert(result, "addMulULong(bi1,nrULong) should equal 73926333.")
        //-- mpz_submul (with type BigInt and BigInt)
        bi3.subMul(bi1, op2: bi2)
        result = (bi3.toString() == "49284333")
        XCTAssert(result, "addMul(bi1,bi2) should equal 49284333.")
        //-- mpz_submul_ui (with type BigInt and ULong)
        bi3.subMulULong(bi1, op2: nrULong)
        result = (bi3.toString() == "333")
        XCTAssert(result, "addMulULong(bi1,nrULong) should equal 333.")
        //-- mpz_mul_2exp with instance method:
        bi3 = BigInt(nr: bi2)
        var expULong: UInt = 22
        bi3.mul2Exp(expULong)   //= 222 * 2^22
        result = (bi3.toString() == "931135488")
        XCTAssert(result, "Mul2Exp(222,22) should equal 931135488.")
        //-- mpz_mul_2exp with class method:
        bi3 = BigInt.mul2Exp(bi1, exp: 11) //=11100 * 2^11
        result = (bi3.toString() == "227328000")
        XCTAssert(result, "Mul2Exp(222,22) should equal 227328000.")
    }
    
    func test05_05_Arithmetic_Multiply_Operators() {
        var bi1 = BigInt(nr: 111_000)
        var bi2 = BigInt(nr: 000_222)
        var nrLong : Int = -333_000
        var nrULong : UInt = 000_444
        
        // Test * (BIOP_10) operator with:
        //-- type BigInt and BigInt
        var bi3 = bi1 * bi2
        var result = (bi3.toString() == "24642000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal 24642000.")
        //-- type BigInt and Long
        bi3 = bi1 * nrLong
        result = (bi3.toString() == "-36963000000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal -36963000000.")
        //-- type BigInt and ULong
        bi3 = bi1 * nrULong
        result = (bi3.toString() == "49284000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal 49284000.")
        //-- type Long and BigInt
        bi3 = nrLong * bi1
        result = (bi3.toString() == "-36963000000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal -36963000000.")
        //-- type ULong and BigInt
        bi3 = nrULong * bi1
        result = (bi3.toString() == "49284000")
        XCTAssert(result, "Mul(bi1,nrLong) should equal 49284000.")
        
        //NOTE: to prevent the compiler error below with:
        //      bi4 = bi1 * bi3 //Error: 'BigIntObjC is not convertible to BigInt' !??
        //  use the following (downcast) instead:
        //      bi4 = bi1 * (bi3 as BigInt)
        
        // Test complex expression with all possible types e.g.:
        //-- type BigInt, BigIntObjC, Long, BigInt, ULong
        var bi4 = bi1 * (bi3 as BigInt) * nrLong * bi2 * nrULong
        result = (bi4.toString() == "-179559797007456000000000")
        XCTAssert(result, "Complex-Mul should equal -179559797007456000000000.")
    }
    
    func test05_05_Arithmetic_Abs_Neg() {
        var bi1 = BigInt(nr: 123_456_789)
        var bi2 = BigInt(nr: -123_456_789)
        
        // Testing abs with:
        //-- class method
        // NOTE: to prevent error with the following declaration:
        //  var bi3 = BigInt.abs(bi2)              //=Declaration: var bi3: () -> Void
        // use the following syntax instead:
        //  var bi3 : BigIntObjC = BigInt.abs(bi2) //=Declaration: var bi3: BigIntObjC
        var bi3 : BigIntObjC = BigInt.abs(bi2)
        var result = (bi3.toString() == "123456789") && (bi2.toString() == "-123456789")
        XCTAssert(result, "BigInt.abs(bi2) and bi2 should equal 123456789 and -123456789")
        //-- instance method
        bi2.abs()
        result = (bi2.toString() == "123456789")
        XCTAssert(result, "bi2.abs() should equal 123456789")
        
        // Testing neg with:
        //-- class method (=CM)
        bi3 = BigInt.neg(bi2)
        result = (bi3.toString() == "-123456789")
        XCTAssert(result, "CM bi3 = BigInt.neg(bi2) should equal -123456789")
        //-- instance method (=IM)
        bi2.neg()
        result = (bi2.toString() == "-123456789")
        XCTAssert(result, "IM bi2.neg() should equal -123456789")
    }
    
    //MARK: - GMP 5.6 Division Functions ---------------------------------------
    func test05_06_Division_Ceil() {
        // N = Q * D + R
        var bi1N = BigInt(nr: 101)
        var bi1Q = BigInt()
        var bi1D = BigInt(nr: 25)
        var bi1R = BigInt()
        var result = false
        
        // Test divCeilQ (ceil(101/25)=ceil(4.04)=5 -> Q = 5)
        //-- GMP: mpz_cdiv_q with (BigIntObjC *) instance method (=IM):
        var bi2 = bi1N.divCeilQ(bi1D)
        result = (bi2.toString() == "5")
        XCTAssert(result, "IM divCeilQ(101,25) should result in bi2 = 5 !")
        //-- GMP: mpz_cdiv_q with (void) instance method:
        bi1N.divCeilQ(bi1Q, d: bi1D)
        result = (bi1Q.toString() == "5")
        XCTAssert(result, "IM divCeilQ(101,25) should result in bi1Q = 5 !")
        //-- GMP: mpz_cdiv_q with (BigIntObjC *) class method (=CM):
        bi2 = BigInt.divCeilQ(bi1N, d: bi1D)
        result = (bi1Q.toString() == "5")
        XCTAssert(result, "CM divCeilQ(101,25) should result in bi2 = 5 !")
        //-- GMP: mpz_cdiv_q with (void) class method:
        BigInt.divCeilQ(bi1Q, n: bi1N, d: bi1D)
        result = (bi1Q.toString() == "5")
        XCTAssert(result, "CM divCeilQ(101,25) should result in bi1Q = 5 !")
    }
    
//    func test05_06_Division_Floor() {
//        //TODO ?
//    }
    
//    func test05_06_Division_Truncate() {
//        //TODO ?
//    }
    
    func test05_06_Division_Operators() {
        // N = Q * D + R
        var bi1 = BigInt(nr: 101)
        var bi2 = BigInt(nr: -101)
        var bi3 = BigInt(nr: 25)
        var bi4 = BigInt(nr: -25)
        var result = false
        
        // Test * (BIOP_11) operator with:
        //-- type BigInt and BigInt
        var biQ = bi1 / bi3
        result = (biQ.toString() == "4")
        XCTAssert(result, "BigInt / BigInt should result in biQ = 4 !")
        //-- type BigInt and -BigInt
        biQ = bi1 / bi4
        result = (biQ.toString() == "-4")
        XCTAssert(result, "BigInt / -BigInt should result in biQ = -4 !")
        //-- type -BigInt and BigInt
        biQ = bi2 / bi3
        result = (biQ.toString() == "-4")
        XCTAssert(result, "-BigInt / BigInt should result in biQ = -4 !")
        //-- type -BigInt and -BigInt
        biQ = bi2 / bi4
        result = (biQ.toString() == "4")
        XCTAssert(result, "-BigInt / -BigInt should result in biQ = 4 !")
        
        var sLong : Int = 25
        //-- type BigInt and SLong
        biQ = bi1 / sLong
        result = (biQ.toString() == "4")
        XCTAssert(result, "BigInt / SLong should result in biQ = 4 !")
        //-- type BigInt and -SLong
        biQ = bi1 / -sLong
        result = (biQ.toString() == "-4")
        XCTAssert(result, "BigInt / -SLong should result in biQ = -4 !")
        //-- type -BigInt and SLong
        biQ = bi2 / sLong
        result = (biQ.toString() == "-4")
        XCTAssert(result, "-BigInt / SLong should result in biQ = -4 !")
        //-- type -BigInt and -SLong
        biQ = bi2 / -sLong
        result = (biQ.toString() == "4")
        XCTAssert(result, "-BigInt / -SLong should result in biQ = 4 !")
        
        var uLong : UInt = 33
        //-- type BigInt and ULong
        biQ = bi1 / uLong
        result = (biQ.toString() == "3")
        XCTAssert(result, "BigInt / ULong should result in biQ = 3 !")
        //-- type -BigInt and ULong
        biQ = bi2 / uLong
        result = (biQ.toString() == "-3")
        XCTAssert(result, "-BigInt / ULong should result in biQ = -3 !")
        
        //-- type SLong and BigInt
        sLong = 2300
        biQ = sLong / bi1
        result = (biQ.toString() == "22")
        XCTAssert(result, "SLong / BigInt should result in biQ = 22 !")
        //-- type -SLong and BigInt
        biQ = -sLong / bi1
        result = (biQ.toString() == "-22")
        XCTAssert(result, "-SLong / BigInt should result in biQ = -22 !")
        //-- type SLong and -BigInt
        biQ = sLong / bi2
        result = (biQ.toString() == "-22")
        XCTAssert(result, "SLong / -BigInt should result in biQ = -22 !")
        //-- type -SLong and -BigInt
        biQ = -sLong / bi2
        result = (biQ.toString() == "22")
        XCTAssert(result, "-SLong / -BigInt should result in biQ = 22 !")
        
        //-- type ULong and BigInt
        uLong = 1200
        biQ = uLong / bi1
        result = (biQ.toString() == "11")
        XCTAssert(result, "ULong / BigInt should result in biQ = 11 !")
        //-- type ULong and -BigInt
        biQ = uLong / bi2
        result = (biQ.toString() == "-11")
        //        println("X. biQ=\(biQ.toString()), result=\(result)")
        XCTAssert(result, "ULong / -BigInt should result in biQ = -11 !")
    }
    
    func test05_06_Division_Mod() {
        // N = Q * D + R
        var bi1 = BigInt(nr: 123456)
        var bi2 = BigInt(nr: -123456)
        var bi3 = BigInt(nr: 78)
        var bi4 = BigInt(nr: -78)
        var result = false
        
        //-- type BigInt and BigInt
        var biQ = bi1.mod(bi3)
        result = (biQ.toString() == "60")
        XCTAssert(result, "IM BigInt % BigInt should result in biQ = 60 !")
        
        //-- type BigInt and -BigInt
        biQ = bi1.mod(bi4)
        result = (biQ.toString() == "60")
        XCTAssert(result, "IM BigInt % -BigInt should result in biQ = 60 !")
        
        //-- type -BigInt and BigInt
        biQ = bi2.mod(bi3)
        result = (biQ.toString() == "-60")
        XCTAssert(result, "IM BigInt % BigInt should result in biQ = -60 !")
        
        //-- type -BigInt and -BigInt
        biQ = bi2.mod(bi4)
        result = (biQ.toString() == "-60")
        XCTAssert(result, "IM BigInt % -BigInt should result in biQ = -60 !")
    }
    
    func test05_06_Division_Mod_Operators() {
        // N = Q * D + R
        var bi1 = BigInt(nr: 123456)
        var bi2 = BigInt(nr: -123456)
        var bi3 = BigInt(nr: 78)
        var bi4 = BigInt(nr: -78)
        var result = false
        
        // Test % (BIOP_12) operator with:
        //-- type BigInt and BigInt
        var biQ = bi1 % bi3
        result = (biQ.toString() == "60")
        XCTAssert(result, "BigInt % BigInt should result in biQ = 60 !")
        
        //-- type BigInt and SLong
        var sLong : Int = -78
        biQ = bi1 % sLong
        result = (biQ.toString() == "60")
        XCTAssert(result, "BigInt % BigInt should result in biQ = 60 !")
        
        //-- type BigInt and ULong
        var uLong : UInt = 78
        biQ = bi1 % uLong
        result = (biQ.toString() == "60")
        XCTAssert(result, "BigInt % BigInt should result in biQ = 60 !")
    }
    
    //MARK: - GMP 5.7 Exponentiation Functions ---------------------------------
    func test05_07_Exponentiation() {
        var bi1 = BigInt(nr: 29)
        var bi2 = BigInt(nr: -29)
        var exp1 : UInt = 23
        var result = false
        
        // Testing power with:
        //-- class method (=CM)
        var biPow = BigInt.power(bi2, exp: exp1)
        result = (biPow.toString() == "-4316720717749415770740818372739989")
        XCTAssert(result, "CM biPow = BigInt.power(bi2,exp1) should equal -4316720717749415770740818372739989")
        //-- instance method (=IM)
        biPow = BigInt(nr: 29)
        biPow.power(exp1)
        result = (biPow.toString() == "4316720717749415770740818372739989")
        XCTAssert(result, "IM bi1.power(exp1) should result in: 4316720717749415770740818372739989")
    }
    
    func test05_07_Exponentiation_Operators() {
        var bi1 = BigInt(nr: 29)
        var bi2 = BigInt(nr: -29)
        var exp1 : UInt = 23
        var result = false
        
        // Test ** (BIOP_07) operator with:
        //-- type BigInt and ULong
        var biPow = bi1 ** exp1
        result = (biPow.toString() == "4316720717749415770740818372739989")
        XCTAssert(result, "CM biPow = BigInt.power(bi2,exp1) should equal 4316720717749415770740818372739989")
        //-- type -BigInt and ULong
        biPow = bi2 ** exp1
        result = (biPow.toString() == "-4316720717749415770740818372739989")
        XCTAssert(result, "CM biPow = BigInt.power(bi2,exp1) should equal -4316720717749415770740818372739989")
    }
    
    //MARK: - GMP 5.8 Root Extraction Functions --------------------------------
    func test05_08_RootExtraction() {
        // Test isPerfectPower with:
        var err : NSError?
        //-- class method: 895430243255237372246531 = 11^23
        var bi1 = BigInt(nr: "895430243255237372246531", error: &err)
        var isPfPow = BigInt.isPerfectPower(bi1)
        XCTAssertTrue(isPfPow, "CM isPerfectPower(895430243255237372246531) should equal 'true'")
        //-- class method: 40353596 = 7^9 - 11
        bi1 = BigInt(nr: 40353596)
        isPfPow = BigInt.isPerfectPower(bi1)
        XCTAssertFalse(isPfPow, "CM isPerfectPower(40353596) should equal 'false'")
        //-- instance method:
        isPfPow = bi1.isPerfectPower()
        XCTAssertFalse(isPfPow, "IM bi1.isPerfectPower() should equal 'false'")
        //-- instance method: -134217728 = (-8)^9
        bi1 = BigInt(nr: -134217728)
        isPfPow = bi1.isPerfectPower()
        XCTAssertTrue(isPfPow, "IM -bi1.isPerfectPower() should equal 'true'")
        
        // Test isPerfectSquare with:
        //-- class method: 15241578750190521 = 123456789^2
        var bi2 = BigInt(nr: 15241578750190521)
        var isPfSqr = BigInt.isPerfectSquare(bi2)
        XCTAssertTrue(isPfSqr, "CM isPerfectSquare(bi2) should equal 'true'")
        //-- class method: 15241578750190520 = 123456789^2 - 1
        bi2 = BigInt(nr: 15241578750190520)
        isPfSqr = BigInt.isPerfectSquare(bi2)
        XCTAssertFalse(isPfSqr, "CM isPerfectSquare(bi2) should equal 'false'")
        //-- instance method: 15241578750190520 = 123456789^2 - 1
        isPfSqr = bi2.isPerfectSquare()
        XCTAssertFalse(isPfSqr, "IM bi2.isPerfectSquare() should equal 'false'")
        //-- instance method: 15241578750190521 = 123456789^2
        bi2 = BigInt(nr: 15241578750190521)
        isPfSqr = bi2.isPerfectSquare()
        XCTAssertTrue(isPfSqr, "IM bi2.isPerfectSquare() should equal 'true'")
        
        // Test root with class method: 239072435685151324847153^(1/19) => 17
        var biRoot = BigInt.root(BigInt(nr: "239072435685151324847153", error: &err), n: 19)
        var result = (biRoot == 17) && (err == nil)
        XCTAssert(result, "CM root(BigInt,23) should equal 17")
        // Test root with instance method: bi1^(1/16) =>
        var bi3 = BigInt(nr: 4294967296)
        biRoot = bi3.root(16)
        result = (biRoot == 4) && (err == nil)
        XCTAssert(result, "IM bi3.root(16) should equal 4")
        // Test root with instance setRoot method
        bi3.setRoot(16)
        XCTAssert((bi3 == 4), "IM bi3.setRoot(16) should equal 4")
        
        // Test sqrt with class method
        var bi4 = BigInt(nr: 65556)
        var biSqrt = BigInt.sqrt(bi4)
        XCTAssert((biSqrt == 256), "CM sqrt(bi4) should equal 256")
        // Test sqrt with instance method
        biSqrt = bi4.sqrt()
        XCTAssert((biSqrt == 256), "IM bi4.sqrt() should equal 256")
        // Test sqrt with instance setSqrt method
        bi4.setSqrt()
        XCTAssert((bi4 == 256), "IM sqrt(bi4) should equal 256")
    }
    
//    func test05_09_NumberTheoretic() {
//    }
    
    //MARK: - GMP 5.10 Comparison Functions ------------------------------------
    func test05_10_Comparison() {
        var bi1 = BigInt(nr: -111)
        var bi2 = BigInt(nr: 0)
        var bi3 = BigInt(nr: 111)
        var sLong : Int = -222
        var uLong : UInt = 222
        var result = false
        
        // Testing compare with:
        //-- type -BigInt and BigInt => bi1 less than bi2
        var cmpRes = bi1.compare(bi2)
        result = (cmpRes == -1)
        XCTAssert(result, "bi1.compare(bi2) should result in: -1")
        //-- type BigInt and 0 => bi2 equals 0
        cmpRes = bi2.compare(BigInt(nr: 0))
        result = (cmpRes == 0)
        XCTAssert(result, "bi2.compare(0) should result in: 0")
        //-- type BigInt and BigInt => bi3 greater than bi2
        cmpRes = bi3.compare(bi2)
        result = (cmpRes == 1)
        XCTAssert(result, "bi3.compare(bi2) should result in: 1")
        //-- type BigInt and SLong
        cmpRes = bi1.compareWithSLong(sLong)
        result = (cmpRes == 1)
        XCTAssert(result, "bi1.compare(sLong) should result in: 1")
        //-- type BigInt and ULong
        cmpRes = bi3.compareWithULong(uLong)
        result = (cmpRes == -1)
        XCTAssert(result, "bi3.compare(uLong) should result in: -1")
        
        // Testing equals with type BigInt and BigInt
        result = bi1.equals(BigInt(nr: -111))
        XCTAssert(result, "bi1.equals(-111) should result in: true")
        result = (bi1.equals(bi2) == false)
        XCTAssert(result, "bi1.equals(bi2) should result in: false")
        
        // Testing sign with class method.
        result = (BigInt.sign(bi1) == -1)
        XCTAssert(result, "CM bi1.sign() should result in: -1")
        result = (BigInt.sign(bi2) == 0)
        XCTAssert(result, "CM bi2.sign() should result in: 0")
        result = (BigInt.sign(bi3) == 1)
        XCTAssert(result, "CM bi3.sign() should result in: 1")
        // Testing sign with instance method.
        result = (bi1.sign() == -1)
        XCTAssert(result, "IM bi1.sign() should result in: -1")
        result = (bi2.sign() == 0)
        XCTAssert(result, "IM bi2.sign() should result in: 0")
        result = (bi3.sign() == 1)
        XCTAssert(result, "IM bi3.sign() should result in: 1")
    }
    
    func test05_10_Comparison_Operators() {
        var bi1 = BigInt(nr: -1234567890)
        var bi2 = BigInt(nr: 0)
        var bi3 = BigInt(nr: 987654321)
        var sLong : Int = -1357924680
        var uLong : UInt = 2468013579
        var result = false
        
        // Test < (BIOP_27) operator with:
        //-- type BigInt and BigInt
        XCTAssert(bi1 < bi2, "bi1 < bi2 should result in: true")
        //-- type BigInt and SLong
        XCTAssertFalse(bi1 < sLong, "bi1 < sLong should result in: false")
        //-- type BigInt and ULong
        XCTAssertTrue(bi1 < uLong, "bi1 < uLong should result in: true")
        //-- type SLong and BigInt
        XCTAssertTrue(sLong < bi1, "sLong < bi1 should result in: true")
        //-- type ULong and BigInt
        XCTAssertFalse(uLong < bi1, "uLong < bi1 should result in: false")
        
        // Test <= (BIOP_28) operator with:
        //-- type BigInt and BigInt
        XCTAssert(bi1 <= bi1, "bi1 <= bi1 should result in: true")
        //-- type BigInt and SLong
        XCTAssertFalse(bi1 <= sLong, "bi1 <= sLong should result in: false")
        //-- type BigInt and ULong
        XCTAssertTrue(bi1 <= uLong, "bi1 <= uLong should result in: true")
        //-- type SLong and BigInt
        XCTAssertTrue(sLong <= bi1, "sLong <= bi1 should result in: true")
        //-- type ULong and BigInt
        XCTAssertFalse(uLong <= bi1, "uLong <= bi1 should result in: false")
        
        // Test > (BIOP_29) operator with:
        //-- type BigInt and BigInt
        XCTAssertFalse(bi1 > bi1, "bi1 > bi1 should result in: false")
        //-- type BigInt and SLong
        XCTAssertTrue(bi1 > sLong, "bi1 > sLong should result in: true")
        //-- type BigInt and ULong
        XCTAssertFalse(bi1 > uLong, "bi1 > uLong should result in: false")
        //-- type SLong and BigInt
        XCTAssertFalse(sLong > bi1, "sLong > bi1 should result in: false")
        //-- type ULong and BigInt
        XCTAssertTrue(uLong > bi1, "uLong > bi1 should result in: true")
        
        // Test >= (BIOP_30) operator with:
        //-- type BigInt and BigInt
        XCTAssertTrue(bi1 >= bi1, "bi1 >= bi1 should result in: true")
        //-- type BigInt and SLong
        XCTAssertTrue(bi1 >= sLong, "bi1 >= sLong should result in: true")
        //-- type BigInt and ULong
        XCTAssertFalse(bi1 >= uLong, "bi1 >= uLong should result in: false")
        //-- type SLong and BigInt
        XCTAssertFalse(sLong >= bi1, "sLong >= bi1 should result in: false")
        //-- type ULong and BigInt
        XCTAssertTrue(uLong >= bi1, "uLong >= bi1 should result in: true")
        
        // Test == (BIOP_31) operator with:
        //-- type BigInt and BigInt
        XCTAssertTrue(bi1 == bi1, "bi1 == bi1 should result in: true")
        //-- type BigInt and SLong
        XCTAssertFalse(bi1 == sLong, "bi1 == sLong should result in: false")
        //-- type BigInt and ULong
        XCTAssertFalse(bi1 == uLong, "bi1 == uLong should result in: false")
        //-- type SLong and BigInt
        XCTAssertFalse(sLong == bi1, "sLong == bi1 should result in: false")
        //-- type ULong and BigInt
        XCTAssertFalse(uLong == bi1, "uLong == bi1 should result in: false")
        
        // Test != (BIOP_32) operator with:
        //-- type BigInt and BigInt
        XCTAssertFalse(bi1 != bi1, "bi1 != bi1 should result in: false")
        //-- type BigInt and SLong
        XCTAssertTrue(bi1 != sLong, "bi1 != sLong should result in: true")
        //-- type BigInt and ULong
        XCTAssertTrue(bi1 != uLong, "bi1 != uLong should result in: true")
        //-- type SLong and BigInt
        XCTAssertTrue(sLong != bi1, "sLong != bi1 should result in: true")
        //-- type ULong and BigInt
        XCTAssertTrue(uLong != bi1, "uLong != bi1 should result in: true")
    }
    
//
//    func test05_11_LogicalAndBitManipulation() {
//    }
//
//    func test05_12_InputAndOutput() {
//    }
//
//    func test05_13_RandomNumbers() {
//    }
//    
//    func test05_14_IntegerImportAndExport() {
//    }
//    
//    func test05_15_Miscellaneous() {
//    }
//    
//    func test05_16_Special() {
//    }
    
}
