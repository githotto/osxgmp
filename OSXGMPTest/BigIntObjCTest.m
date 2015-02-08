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
//  BigIntObjCTest.m
//  OSXGMP
//
//  Created by Otto van Verseveld on 11/15/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BigIntObjC.h"

@interface BigIntObjCTest : XCTestCase

@end

@implementation BigIntObjCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test05_01_Initialization {
    // Test default initializer.
    BigIntObjC *bi = [[BigIntObjC alloc] init];
    Boolean result = [[bi toString] isEqualToString:@"0"];
    XCTAssert(result, @"Default initializer should be 0!");
    
    // Test default string-initializer.
    NSError *err;
    bi = [[BigIntObjC alloc] initWithString:@"" error:&err];
    result = [[bi toString] isEqualToString:@"0"];
    XCTAssert(result, @"Overloaded initializer(String) should be 0!");
    
    // Test for error in string-initializer with invalid number for base.
    bi = [[BigIntObjC alloc] initWithString:@"12" inBase: 2 error:&err];
    XCTAssert((err != nil), @"Init BigInt should fail with err=invalidStringNumberForBase.");
    
    // Test for no-error in string-initializer with valid number for base.
    bi = [[BigIntObjC alloc] initWithString:@"12" inBase: 3 error:&err];
    XCTAssert((err == nil), @"Init BigInt should NOT fail.");
}

- (void)test05_02_Assignment {
    // Test string-initializer with invalid number for base.
    NSError *err;
    BigIntObjC *bi = [[BigIntObjC alloc] initWithString:@"12" inBase:2 error:&err];
    Boolean result = [[bi toString] isEqualToString:@"0"];
    XCTAssert(result, @"BigInt should be initialized to default value: 0");
    
    // Test string-initializer with valid number for base.
    bi = [[BigIntObjC alloc] initWithString:@"12" inBase:3 error:&err];
    result = [[bi toString] isEqualToString:@"5"];
    XCTAssert(result, @"BigInt should be initialized to value: 5");
    
    // Test value of large number string-initializer.
    bi = [[BigIntObjC alloc] initWithString:@"1234567890987654321" error:&err];
    result = [[bi toString] isEqualToString:@"1234567890987654321"];
    XCTAssert(result, @"Initializer-NSString should set BigInt to 1234567890987654321!");
    
    // Test swapping two variables using instance and method.
    bi = [[BigIntObjC alloc] initWithSLong:11];
    BigIntObjC *biSwap = [[BigIntObjC alloc] initWithSLong:2222];
    [bi swap:biSwap];
    result = (([[bi toString] isEqualToString:@"2222"]) && ([[biSwap toString] isEqualToString:@"11"]));
    XCTAssert(result, @"Swapping bi,biSwap should result in '2222' and '11' !");
    
    // Test swapping two variables using Class method.
    [BigIntObjC swap:bi bn2:biSwap];
    result = (([[bi toString] isEqualToString:@"11"]) && ([[biSwap toString] isEqualToString:@"2222"]));
    XCTAssert(result, @"Swapping bi,biSwap should result in '11' and '2222' !");
}

- (void)test05_03_CombinedInitializationAndAssignment {
    // Test initializer-BigInt.
    BigIntObjC *bi = [[BigIntObjC alloc] initWithBigInt:[[BigIntObjC alloc] initWithSLong:2]];
    Boolean result = [[bi toString] isEqualToString:@"2"];
    XCTAssert(result, @"Initializer-BigInt should be 2!");
    
    // Test initializer-Double.
    bi = [[BigIntObjC alloc] initWithDouble:2.9];
    result = [[bi toString] isEqualToString:@"2"];
    XCTAssert(result, @"Initializer-Double(2.9) should truncate to 2!");
    bi = [[BigIntObjC alloc] initWithDouble:3.0];
    result = [[bi toString] isEqualToString:@"3"];
    XCTAssert(result, @"Initializer-Double(3.0) should truncate to 3!");
    bi = [[BigIntObjC alloc] initWithDouble:3.1];
    result = [[bi toString] isEqualToString:@"3"];
    XCTAssert(result, @"Initializer-Double(3.1) should truncate to 3!");
}

- (void)test05_06_Division_Ceil {
    // N = Q * D + R
    BigIntObjC *bi1N = [[BigIntObjC alloc] initWithSLong:101];
    BigIntObjC *bi1Q = [BigIntObjC new];
    BigIntObjC *bi1D = [[BigIntObjC alloc] initWithSLong:25];
    BigIntObjC *bi1R = [BigIntObjC new];
    Boolean result = false;
    
    // Test divCeilQ (ceil(101/25)=ceil(4.04)=5 -> Q = 5)
    //-- GMP: mpz_cdiv_q with (BigIntObjC *) instance-method (=IM):
    BigIntObjC *bi2 = [bi1N divCeilQ:bi1D];
    result = [[bi2 toString] isEqualToString:@"5"];
    XCTAssert(result, @"IM divCeilQ(101,25) should result in bi2 = 5 !");
    //-- GMP: mpz_cdiv_q with (void) instance-method:
    [bi1N divCeilQ:bi1Q d:bi1D];
    result = [[bi1Q toString] isEqualToString:@"5"];
    XCTAssert(result, @"IM divCeilQ(101,25) should result in bi1Q = 5 !");
    //-- GMP: mpz_cdiv_q with (BigIntObjC *) class-method (=CM):
    bi2 = [BigIntObjC divCeilQ:bi1N d:bi1D];
    result = [[bi2 toString] isEqualToString:@"5"];
    XCTAssert(result, @"CM divCeilQ(101,25) should result in bi2 = 5 !");
    //-- GMP: mpz_cdiv_q with (void) class-method:
    [BigIntObjC divCeilQ:bi1Q n:bi1N d:bi1D];
    result = [[bi1Q toString] isEqualToString:@"5"];
    XCTAssert(result, @"CM divCeilQ(101,25) should result in bi1Q = 5 !");
    
    // Test divCeilR (101 = 5 * 25 - 24 -> R = -24)
    //-- GMP: mpz_cdiv_r with instance-method:
    [bi1N divCeilR:bi1R d:bi1D];
    result = [[bi1R toString] isEqualToString:@"-24"];
    XCTAssert(result, @"IM divCeilR(101,25) should result in bi1R = -24 !");
    //-- GMP: mpz_cdiv_r with class-method:
    [BigIntObjC divCeilQ:bi1Q n:bi1N d:bi1D];
    result = [[bi1R toString] isEqualToString:@"-24"];
    XCTAssert(result, @"CM divCeilR(101,25) should result in bi1R = -24 !");
    
    // Test divCeilQR (101 = 5 * 25 - 24 -> Q = 5, R = -24)
    //-- GMP: mpz_cdiv_qr with instance-method:
    [bi1N divCeilQR:bi1Q r:bi1R d:bi1D];
    result = [[bi1Q toString] isEqualToString:@"5"] && [[bi1R toString] isEqualToString:@"-24"];
    XCTAssert(result, @"IM divCeilQR(101,25) should result in bi1Q = 5 and bi1R = -24 !");
    NSLog(@"X bi1N=%@", [bi1N toString]);
    NSLog(@"X bi1Q=%@", [bi1Q toString]);
    NSLog(@"X bi1D=%@", [bi1D toString]);
    NSLog(@"X bi1R=%@", [bi1R toString]);
    
    
    // Test divFloorQ (Q = floor(99/25)=floor(3.96)=3 -> bi1N=3)
    //-- mpz_fdiv_q with instance method:
    //-- mpz_fdiv_q with class method:
}

@end
