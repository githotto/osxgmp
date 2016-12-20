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
//  ObjCWiGMP.m
//  SwiGMP
//
//  Created by Otto van Verseveld on 9/16/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

#import "BigIntError.h"
#import "BigIntObjC.h"

@implementation BigIntObjC


#pragma mark - Initialization / removal
- (void)dealloc {
//    NSLog(@"Calling dealloc and mpz_clear ...");
    mpz_clear(bigInt);
}


#pragma mark - GMP Paragraph 5.1 Initialization Functions
- (id)init {
    self = [super init];
    mpz_init(bigInt);
    return self;
}

- (void)clear {
    mpz_clear(bigInt);
}


#pragma mark - GMP Paragraph 5.2 Assignment Functions
- (void)setFromBigFloat:(const mpf_t)op {
    // Arbitrary precision mantissa with a limited precision exponent.
    mpz_set_f(bigInt, op);
}

- (void)setFromBigInt:(BigIntObjC *)bigNr {
    mpz_set(bigInt, bigNr->bigInt);
}

- (void)setFromBigRational:(const mpq_t)op {
    // Has a multiple precision fraction.
    mpz_set_q(bigInt, op);
}

- (void)setFromDouble:(double)doubleNr {
    mpz_set_d(bigInt, doubleNr);
}

- (void)setFromSLong:(long)longNr {
    mpz_set_si(bigInt, longNr);
}

- (int)setFromString:(NSString *)stringNr error:(NSError **)error {
    return [self setFromString:stringNr withBase:10 error:error];
}

- (int)setFromString:(NSString *)stringNr withBase:(int)base error:(NSError **)error {
    *error = nil;
    int retVal = 0;
    // NOTE: see GMP Paragraph 5.2 for valid base values.
    if ((base == 0) || ((base > 1) && (base < 63))) {
        retVal = mpz_set_str(bigInt, [stringNr UTF8String], base);
        if (retVal == -1) {
            if (stringNr.length == 0) {
                *error = [BigIntError emptyStringNumber];
            } else {
                *error = [BigIntError invalidNumberFormat];
                /*
                 * TODO/NOTE: we may use NSScanner to determine if the stringNr
                 * contains e.g. digits greater than the current base allows:
                 *
                 // TODO: Determine appropriate characterset ...
                 NSCharacterSet *charSet = [NSCharacterSet decimalDigitCharacterSet];
                 [scanner scanCharactersFromSet:charSet intoString:nil];
                 // Shorter way to scan for valid int with base=10:
                 NSScanner *scanner = [NSScanner scannerWithString:stringNr];
                 int nr;
                 if ([scanner scanInt:&nr] == NO) {
                     error = [BigIntError invalidNumberFormat];
                 }
                 */
            }
        }
    } else {
        *error = [BigIntError invalidBaseNumber];
    }
//    NSLog(@"setFromString(nr: %@, base: %d) => %d", stringNr, base, retVal);
    return retVal;
}

- (void)setFromULong:(GMP_ULONG)ulongNr {
    mpz_set_ui(bigInt, ulongNr);
}

- (void)swap:(BigIntObjC *)bn {
    mpz_swap(bigInt, bn->bigInt);
}

+ (void)swap:(BigIntObjC *)bn1 bn2:(BigIntObjC *)bn2 {
    mpz_swap(bn1->bigInt, bn2->bigInt);
}


#pragma mark - GMP Paragraph 5.3 Combined Initialization and Assignment Functions.
- (id)initWithBigInt:(BigIntObjC *)nr {
    self = [super init];
    mpz_init_set(bigInt, nr->bigInt);
    return self;
}

- (id)initWithDouble:(double)nr {
    self = [super init];
    mpz_init_set_d(bigInt, nr);
    return self;
}

- (id)initWithSLong:(GMP_SLONG)nr {
    self = [super init];
    mpz_init_set_si(bigInt, nr);
    return self;
}

- (id)initWithString:(NSString *)string error:(NSError **)error {
    return [self initWithString:string inBase:10 error:error];
}

- (id)initWithString:(NSString *)string inBase:(int)base error:(NSError **)error {
    self = [super init];
    [self setFromString:string withBase:base error:error];
    return self;
}

- (id)initWithULong:(GMP_ULONG)nr {
    self = [super init];
    mpz_init_set_ui(bigInt, nr);
    return self;
}


#pragma mark - GMP Paragraph 5.4 Conversion Functions
- (double)toDouble {
    return mpz_get_d(bigInt);
}

- (GMP_SLONG)toSLong {
    return mpz_get_si(bigInt);
}

- (NSString *)toString {
    return [self toStringInBase:10];
}

- (NSString *)toStringInBase:(int)base {
    size_t bnSize = mpz_sizeinbase(bigInt, base);
    char str[bnSize];
    char *res = mpz_get_str(str, base, bigInt);
    NSString *nstr;
    if (res == NULL) {
        nstr = [[NSString alloc] initWithUTF8String:str];
    } else {
        nstr = [[NSString alloc] initWithUTF8String:res];
    }
    return nstr;
}

- (GMP_ULONG)toULong {
    return mpz_get_ui(bigInt);
}


#pragma mark - GMP Paragraph 5.5 Arithmetic Functions
- (void)abs {
    mpz_abs(self->bigInt, self->bigInt);
}

+ (BigIntObjC *)abs:(BigIntObjC *)op {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op];
    [bn abs];
    return bn;
}

- (void)add:(BigIntObjC *)op {
    mpz_add(bigInt, bigInt, op->bigInt);
}

+ (BigIntObjC *)add:(BigIntObjC *)op1 op2:(BigIntObjC *)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn add:op2];
    return bn;
}

- (void)addSLong:(GMP_SLONG)op {
    if (op < 0) {
        mpz_sub_ui(bigInt, bigInt, -op);
    } else {
        mpz_add_ui(bigInt, bigInt, op);
    }
}

+ (BigIntObjC *)addSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn addSLong:op2];
    return bn;
}

- (void)addULong:(GMP_ULONG)op {
    mpz_add_ui(bigInt, bigInt, op);
}

- (void)addMul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2 {
    mpz_addmul(bigInt, op1->bigInt, op2->bigInt);
}

- (void)addMulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2 {
    mpz_addmul_ui(bigInt, op1->bigInt, op2);
}

+ (BigIntObjC *)addULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn addULong:op2];
    return bn;
}

- (void)mul:(BigIntObjC *)op {
    mpz_mul(bigInt, bigInt, op->bigInt);
}

+ (BigIntObjC *)mul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn mul:op2];
    return bn;
}

- (void)mulSLong:(GMP_SLONG)op {
    mpz_mul_si(bigInt, bigInt, op);
}

+ (BigIntObjC *)mulSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn mulSLong:op2];
    return bn;
}

- (void)mulULong:(GMP_ULONG)op {
    mpz_mul_ui(bigInt, bigInt, op);
}

+ (BigIntObjC *)mulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn mulULong:op2];
    return bn;
}

- (void)mul2Exp:(mp_bitcnt_t)op2 {
    mpz_mul_2exp(bigInt, bigInt, op2);
}

+ (BigIntObjC *)mul2Exp:(BigIntObjC *)op1 exp:(mp_bitcnt_t)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    mpz_mul_2exp(bn->bigInt, op1->bigInt, op2);
    return bn;
}

- (void)neg {
    mpz_neg(bigInt, bigInt);
}

+ (BigIntObjC *)neg:(BigIntObjC *)op {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op];
    [bn neg];
    return bn;
}

- (void)sub:(BigIntObjC *)op {
    mpz_sub(bigInt, bigInt, op->bigInt);
}

+ (BigIntObjC *)sub:(BigIntObjC *)op1 op2:(BigIntObjC *)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn sub:op2];
    return bn;
}

- (void)subSLong:(GMP_SLONG)op {
    if (op < 0) {
        mpz_add_ui(bigInt, bigInt, -op);
    } else {
        mpz_sub_ui(bigInt, bigInt, op);
    }
}

+ (BigIntObjC *)subSLong:(BigIntObjC *)op1 op2:(GMP_SLONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn subSLong:op2];
    return bn;
}

- (void)subULong:(GMP_ULONG)op {
    mpz_sub_ui(bigInt, bigInt, op);
}

+ (BigIntObjC *)subULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2 {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:op1];
    [bn subULong:op2];
    return bn;
}

- (void)subMul:(BigIntObjC *)op1 op2:(BigIntObjC *)op2 {
    mpz_submul(bigInt, op1->bigInt, op2->bigInt);
}

- (void)subMulULong:(BigIntObjC *)op1 op2:(GMP_ULONG)op2 {
    mpz_submul_ui(bigInt, op1->bigInt, op2);
}


#pragma mark - GMP Paragraph 5.6 Division Functions (Ceil)
- (BigIntObjC *)divCeilQ:(BigIntObjC *)d {
    BigIntObjC *q = [BigIntObjC new];
    [self divCeilQ:q d:d];
    return q;
}

+ (BigIntObjC *)divCeilQ:(BigIntObjC *)n d:(BigIntObjC *)d {
    return [n divCeilQ:d];
}

- (void)divCeilQ:(BigIntObjC *)q d:(BigIntObjC *)d {
    mpz_cdiv_q(q->bigInt, self->bigInt, d->bigInt);
}

+ (void)divCeilQ:(BigIntObjC *)q n:(BigIntObjC *)n d:(BigIntObjC *)d {
    [n divCeilQ:q d:d];
}

- (void)divCeilR:(BigIntObjC *)r d:(BigIntObjC *)d {
    mpz_cdiv_r(r->bigInt, self->bigInt, d->bigInt);
}

+ (void)divCeilR:(BigIntObjC *)r n:(BigIntObjC *)n d:(BigIntObjC *)d {
    [n divCeilQ:r d:d];
}

- (void)divCeilQR:(BigIntObjC *)q r:(BigIntObjC *)r d:(BigIntObjC *)d {
    mpz_cdiv_qr(q->bigInt, r->bigInt, self->bigInt, d->bigInt);
}

-(GMP_ULONG)divCeilQULong:(BigIntObjC *)q d:(GMP_ULONG)d {
    return mpz_cdiv_q_ui(q->bigInt, self->bigInt, d);
}

-(GMP_ULONG)divCeilRULong:(BigIntObjC *)r d:(GMP_ULONG)d {
    return mpz_cdiv_r_ui(r->bigInt, self->bigInt, d);
}

-(GMP_ULONG)divCeilQRULong:(BigIntObjC *)q r:(BigIntObjC *)r d:(GMP_ULONG)d {
    return mpz_cdiv_qr_ui(q->bigInt, r->bigInt, self->bigInt, d);
}

-(GMP_ULONG)divCeilULong:(GMP_ULONG)d {
    return mpz_cdiv_ui(self->bigInt, d);
}

- (void)divCeilQ2Exp:(BigIntObjC *)q b:(mp_bitcnt_t)b {
    return mpz_cdiv_q_2exp(q->bigInt, self->bigInt, b);
}

- (void)divCeilR2Exp:(BigIntObjC *)r b:(mp_bitcnt_t)b {
    return mpz_cdiv_q_2exp(r->bigInt, self->bigInt, b);
}


#pragma mark - GMP Paragraph 5.6 Division Functions (Truncate)
- (void)divTruncateQ:(BigIntObjC *)q d:(BigIntObjC *)d {
    mpz_tdiv_q(q->bigInt, self->bigInt, d->bigInt);
}

+ (void)divTruncateQ:(BigIntObjC *)q n:(BigIntObjC *)n d:(BigIntObjC *)d {
    [n divTruncateQ:q d:d];
}

- (GMP_ULONG)divTruncateQULong:(BigIntObjC *)q d:(GMP_ULONG)d {
    return mpz_tdiv_q_ui(q->bigInt, self->bigInt, d);
}

+ (GMP_ULONG)divTruncateQULong:(BigIntObjC *)q n:(BigIntObjC *)n d:(GMP_ULONG)d {
    return [n divTruncateQULong:q d:d];
}

- (GMP_ULONG)divTruncateULong:(GMP_ULONG)d {
    return mpz_tdiv_ui(self->bigInt, d);
}

+ (GMP_ULONG)divTruncateULong:(BigIntObjC *)n d:(GMP_ULONG)d {
    return [n divTruncateULong:d];
}


#pragma mark - GMP Paragraph 5.6 Division Functions (used by Swift-operators)
- (BigIntObjC *)div:(BigIntObjC *)d {
    BigIntObjC *q = [BigIntObjC new];
    [self divTruncateQ:q d:d];
    return q;
}

+ (BigIntObjC *)div:(BigIntObjC *)n d:(BigIntObjC *)d {
    return [n div:d];
}

- (BigIntObjC *)divSLong:(GMP_SLONG)d {
    BigIntObjC *q = [BigIntObjC new];
    if (d < 0) {
        q = [self divULong: -d];
        [q neg];
    } else {
        q = [self divULong: d];
    }
    return q;
}

+ (BigIntObjC *)divSLong:(BigIntObjC *)n d:(GMP_SLONG)d {
    return [n divSLong:d];
}

- (BigIntObjC *)divULong:(GMP_ULONG)d {
    BigIntObjC *q = [BigIntObjC new];
    mpz_tdiv_q_ui(q->bigInt, self->bigInt, d);
    return q;
}

+ (BigIntObjC *)divULong:(BigIntObjC *)n d:(GMP_ULONG)d {
    return [n divULong:d];
}

- (BigIntObjC *)mod:(BigIntObjC *)d {
    BigIntObjC *r = [BigIntObjC new];
    if ([self compareWithSLong:0] < 0) {
        BigIntObjC *n = [[BigIntObjC alloc] initWithBigInt:self];
        [n neg];
        mpz_mod(r->bigInt, n->bigInt, d->bigInt);
        [r neg];
    } else {
        mpz_mod(r->bigInt, self->bigInt, d->bigInt);
    }
    return r;
}

+ (BigIntObjC *)mod:(BigIntObjC *)n d:(BigIntObjC *)d {
    return [n mod:d];
}


#pragma mark - GMP Paragraph 5.7 Exponential Functions
- (void)power:(GMP_ULONG)exp {
    mpz_pow_ui(bigInt, bigInt, exp);
}

+ (BigIntObjC *)power:(BigIntObjC *)base exp:(GMP_ULONG)exp {
    BigIntObjC *bn = [[BigIntObjC alloc] initWithBigInt:base];
    [bn power:exp];
    return bn;
}

+ (BigIntObjC *)powerULong:(GMP_ULONG)base exp:(GMP_ULONG)exp {
    BigIntObjC *bn = [BigIntObjC new];
    [bn setFromULongPower:base withExp:exp];
    return bn;
}

- (void)setFromULongPower:(GMP_ULONG)base withExp:(GMP_ULONG)exp {
    mpz_ui_pow_ui(bigInt, base, exp);
}


#pragma mark - GMP Paragraph 5.8 Root Extraction Functions
- (bool)isPerfectPower {
    return (mpz_perfect_power_p(self->bigInt) != 0);
}

+ (bool)isPerfectPower:(BigIntObjC *)op {
    return [op isPerfectPower];
}

- (bool)isPerfectSquare {
    return (mpz_perfect_square_p(self->bigInt) != 0);
}

+ (bool)isPerfectSquare:(BigIntObjC *)op {
    return [op isPerfectSquare];
}

- (int)setRoot:(GMP_ULONG)n {
    return mpz_root(self->bigInt, self->bigInt, n);
}

- (BigIntObjC *)root:(GMP_ULONG)n {
    return [BigIntObjC root:self n:n];
}

+ (BigIntObjC *)root:(BigIntObjC *)op n:(GMP_ULONG)n {
    BigIntObjC *rop = [[BigIntObjC alloc] initWithBigInt:op];
    [rop setRoot:n];
    return rop;
}

- (void)setSqrt {
    mpz_sqrt(bigInt, bigInt);
}

- (BigIntObjC *)sqrt {
    return [BigIntObjC sqrt:self];
}

+ (BigIntObjC *)sqrt:(BigIntObjC *)op {
    BigIntObjC *rop = [[BigIntObjC alloc] initWithBigInt:op];
    [rop setSqrt];
    return rop;
}


#pragma mark - GMP Paragraph 5.10 Comparison Functions
- (int)compare:(BigIntObjC *)bn {
    return mpz_cmp(bigInt, bn->bigInt);
}

- (int)compareWithSLong:(GMP_SLONG)slongNr {
    return mpz_cmp_si(bigInt, slongNr);
}

- (int)compareWithULong:(GMP_ULONG)ulongNr {
    return mpz_cmp_ui(bigInt, ulongNr);
}

- (bool)equals:(BigIntObjC *)bn {
    return ([self compare:bn] == 0);
}

- (int)sign {
    return mpz_sgn(self->bigInt);
}

+ (int)sign:(BigIntObjC *)bn {
    return [bn sign];
}


#pragma mark - GMP Paragraph 15.7.4 Fibonacci Numbers
+ (BigIntObjC *)fibonacciN:(GMP_ULONG)n {
    BigIntObjC *fib = [BigIntObjC new];
    mpz_fib_ui (fib->bigInt, n);
    return fib;
}


#pragma mark - Other Functions
- (void)dump {
    [self dump:(@"")];
}

- (void)dump:(NSString *)message {
    gmp_printf("%s%Zd\n", [message UTF8String], bigInt);
}

- (GMP_ULONG)nrDigits {
    return mpz_sizeinbase(bigInt, 10);
}

- (GMP_ULONG)nrDigitsInBase:(int)base {
    return mpz_sizeinbase(bigInt, base);
}

- (void)reverse {
    NSString *strNr = [self toString];
    NSMutableString *reversedString = [NSMutableString new];
    NSInteger charIndex = [strNr length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[strNr substringWithRange:subStrRange]];
    }
    NSError *err;
    BigIntObjC *bnRev = [[BigIntObjC alloc] initWithString:reversedString error:&err];
    [BigIntObjC swap:bnRev bn2:self];
}


#pragma mark - GMP Paragraph 5.9 Number Theoretic Functions
+ (BigIntObjC *)factorial:(unsigned long int)n {
    BigIntObjC *bnFac = [self new];
    mpz_fac_ui(bnFac->bigInt, n);
    return bnFac;
}

+ (bool)isPrimeNr:(unsigned long int)n {
    BigIntObjC *bn = [BigIntObjC new];
    [bn setFromULong:n];
    bool isPrime = [bn isPrime];
    [bn clear];
    return isPrime;
}

- (bool)isPrime {
    int probablePrime = mpz_probab_prime_p(bigInt, 25);
    //    bool isAPrime = (probablePrime != 0);
    //    gmp_printf("isPrime(%Zd) => %s (%d)\n", bigInt, isAPrime ? "yes" : "no", probablePrime);
    return (probablePrime != 0);
}

- (BigIntObjC *)nextPrime {
    BigIntObjC *bn = [BigIntObjC new];
    mpz_nextprime(bn->bigInt, bigInt);
    return bn;
}

- (void)setNextPrime {
    BigIntObjC *np = [self nextPrime];
    [BigIntObjC swap:np bn2:self];
    //    [np clear];
}

@end
