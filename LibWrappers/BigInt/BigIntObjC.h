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
//  BigIntObjC.h
//  BigNumber
//
//  Created by Otto van Verseveld on 9/16/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import "gmp.h"

typedef long int GMP_LONG;
typedef signed long int GMP_SLONG;
typedef unsigned long int GMP_ULONG;
 
@interface BigIntObjC : NSObject {
    mpz_t bigInt;
}


#pragma mark - Initialization / removal
- (void)dealloc;


#pragma mark - GMP Paragraph 5.1 Initialization Functions
- (id)init;
- (void)clear;


#pragma mark - GMP Paragraph 5.2 Assignment Functions
- (void)setFromBigFloat:(const mpf_t)op;
- (void)setFromBigInt:(BigIntObjC *)bigNr;
- (void)setFromBigRational:(const mpq_t)op;
- (void)setFromDouble:(double)doubleNr;
- (void)setFromSLong:(GMP_SLONG)longNr;
- (int)setFromString:(NSString *)stringNr error:(NSError **)error;
- (int)setFromString:(NSString *)stringNr withBase:(int)base error:(NSError **)error;
- (void)setFromULong:(GMP_ULONG)ulongNr;
- (void)swap:(BigIntObjC *)bn;
+ (void)swap:(BigIntObjC *)bn1 bn2:(BigIntObjC *)bn2;


#pragma mark - GMP Paragraph 5.3 Combined Initialization and Assignment Functions.
- (id)initWithBigInt:(BigIntObjC *)nr;
- (id)initWithDouble:(double)nr;
- (id)initWithSLong:(GMP_SLONG)nr;
- (id)initWithString:(NSString *)string error:(NSError **)error;
- (id)initWithString:(NSString *)string inBase:(int)base error:(NSError **)error;
- (id)initWithULong:(GMP_ULONG)nr;


#pragma mark - GMP Paragraph 5.4 Conversion Functions
- (double)toDouble;
- (GMP_SLONG)toSLong;
- (NSString *)toString;
- (NSString *)toStringInBase:(int)base;
- (GMP_ULONG)toULong;


#pragma mark - GMP Paragraph 5.5 Arithmetic Functions
- (void)abs;
+ (BigIntObjC *)abs:(BigIntObjC *)op;

- (void)add:(BigIntObjC *)op;
+ (BigIntObjC *)add:(BigIntObjC *)op1 op2:(BigIntObjC *)op2;
- (void)addSLong:(GMP_SLONG)op;        //NOTE: added for convenience here.
+ (BigIntObjC *)addSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2;
- (void)addULong:(GMP_ULONG)op;
+ (BigIntObjC *)addULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2;

- (void)mul:(BigIntObjC *)op;
+ (BigIntObjC *)mul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2;
- (void)mulSLong:(GMP_SLONG)op;
+ (BigIntObjC *)mulSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2;
- (void)mulULong:(GMP_ULONG)op;
+ (BigIntObjC *)mulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2;
- (void)addMul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2;
- (void)addMulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2;
- (void)mul2Exp:(mp_bitcnt_t)op2;
+ (BigIntObjC *)mul2Exp:(BigIntObjC *)op1 exp:(mp_bitcnt_t)op2;

- (void)neg;
+ (BigIntObjC *)neg:(BigIntObjC *)op;

- (void)sub:(BigIntObjC *)op;
+ (BigIntObjC *)sub:(BigIntObjC *)op1 op2:(BigIntObjC *)op2;
- (void)subSLong:(GMP_SLONG)op;
+ (BigIntObjC *)subSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2;
- (void)subULong:(GMP_ULONG)op;
+ (BigIntObjC *)subULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2;
- (void)subMul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2;
- (void)subMulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2;


#pragma mark - GMP Paragraph 5.6 Division Functions (Ceil)
- (BigIntObjC *)divCeilQ:(BigIntObjC *)d;   // NOTE: replaces call with q-param!
+ (BigIntObjC *)divCeilQ:(BigIntObjC *)n d:(BigIntObjC *)d;
- (void)divCeilQ:(BigIntObjC *)q d:(BigIntObjC *)d;
+ (void)divCeilQ:(BigIntObjC *)q n:(BigIntObjC *)n d:(BigIntObjC *)d;
- (void)divCeilR:(BigIntObjC *)r d:(BigIntObjC *)d;
+ (void)divCeilR:(BigIntObjC *)r n:(BigIntObjC *)n d:(BigIntObjC *)d;
- (void)divCeilQR:(BigIntObjC *)q r:(BigIntObjC *)r d:(BigIntObjC *)d;
- (GMP_ULONG)divCeilQULong:(BigIntObjC *)q d:(GMP_ULONG)d;
- (GMP_ULONG)divCeilRULong:(BigIntObjC *)r d:(GMP_ULONG)d;
- (GMP_ULONG)divCeilQRULong:(BigIntObjC *)q r:(BigIntObjC *)r d:(GMP_ULONG)d;
- (GMP_ULONG)divCeilULong:(GMP_ULONG)d;
- (void)divCeilQ2Exp:(BigIntObjC *)q b:(mp_bitcnt_t)b;
- (void)divCeilR2Exp:(BigIntObjC *)r b:(mp_bitcnt_t)b;


//#pragma mark - GMP Paragraph 5.6 Division Functions (Floor)
//TODO ... ???


#pragma mark - GMP Paragraph 5.6 Division Functions (Truncate)
- (void)divTruncateQ:(BigIntObjC *)q d:(BigIntObjC *)d;
+ (void)divTruncateQ:(BigIntObjC *)q n:(BigIntObjC *)n d:(BigIntObjC *)d;
- (GMP_ULONG)divTruncateQULong:(BigIntObjC *)q d:(GMP_ULONG)d;
+ (GMP_ULONG)divTruncateQULong:(BigIntObjC *)q n:(BigIntObjC *)n d:(GMP_ULONG)d;
- (GMP_ULONG)divTruncateULong:(GMP_ULONG)d;
+ (GMP_ULONG)divTruncateULong:(BigIntObjC *)n d:(GMP_ULONG)d;


#pragma mark - GMP Paragraph 5.6 Division Functions (used by Swift-operators)
- (BigIntObjC *)div:(BigIntObjC *)d;
+ (BigIntObjC *)div:(BigIntObjC *)n d:(BigIntObjC *)d;
- (BigIntObjC *)divSLong:(GMP_SLONG)d;
+ (BigIntObjC *)divSLong:(BigIntObjC *)n d:(GMP_SLONG)d;
- (BigIntObjC *)divULong:(GMP_ULONG)d;
+ (BigIntObjC *)divULong:(BigIntObjC *)n d:(GMP_ULONG)d;
- (BigIntObjC *)mod:(BigIntObjC *)d;
+ (BigIntObjC *)mod:(BigIntObjC *)n d:(BigIntObjC *)d;


#pragma mark - GMP Paragraph 5.7 Exponential Functions
- (void)power:(GMP_ULONG)exp;
+ (BigIntObjC *)power:(BigIntObjC *)base exp:(GMP_ULONG)exp;
+ (BigIntObjC *)powerULong:(GMP_ULONG)base exp:(GMP_ULONG)exp;
- (void)setFromULongPower:(GMP_ULONG)base withExp:(GMP_ULONG)exp;


#pragma mark - GMP Paragraph 5.8 Root Extraction Functions
- (bool)isPerfectPower;
+ (bool)isPerfectPower:(BigIntObjC *)op;
- (bool)isPerfectSquare;
+ (bool)isPerfectSquare:(BigIntObjC *)op;
- (int)setRoot:(GMP_ULONG)n;
- (BigIntObjC *)root:(GMP_ULONG)n;
+ (BigIntObjC *)root:(BigIntObjC *)op n:(GMP_ULONG)n;
- (void)setSqrt;
- (BigIntObjC *)sqrt;
+ (BigIntObjC *)sqrt:(BigIntObjC *)op;


#pragma mark - GMP Paragraph 5.9 Number Theoretic Functions
+ (BigIntObjC *)factorial:(unsigned long int)n;
+ (bool)isPrimeNr:(unsigned long int)n;
- (bool)isPrime;
- (BigIntObjC *)nextPrime;
- (void)setNextPrime;


#pragma mark - GMP Paragraph 5.10 Comparison Functions
- (int)compare:(BigIntObjC *)bn;
- (int)compareWithSLong:(GMP_SLONG)slongNr;
- (int)compareWithULong:(GMP_ULONG)ulongNr;
- (bool)equals:(BigIntObjC *)bn;
- (int)sign;
+ (int)sign:(BigIntObjC *)bn;


#pragma mark - GMP Paragraph 15.7.4 Fibonacci Numbers
+ (BigIntObjC *)fibonacciN:(GMP_ULONG)n;


#pragma mark - Other Functions
- (void)dump;
- (void)dump:(NSString *)message;
- (GMP_ULONG)nrDigits;
- (GMP_ULONG)nrDigitsInBase:(int)base;
- (void)reverse;

@end
