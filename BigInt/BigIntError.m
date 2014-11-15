//
//  BigIntError.m
//  BigNumber
//
//  Created by Otto van Verseveld on 10/17/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

/*
 * EXAMPLE-1: create error with e.g.:
     if (outError) {
         *outError = [BigIntError invalidStringNumberForBase];
         ..
     }
 *
 * EXAMPLE-2: handle error with e.g.:
     if ([error.domain isEqualToString:BigIntErrorDomain]) {
         switch (error.code) {
             case BigIntErrorCode_InvalidStringNumberForBase : {
                 self.handleInvalidBigIntNr = true;
                 ..
         }
     }
 *
 */

#import "BigIntError.h"

NSString * const BigIntErrorDomain = @"nl.tofh.BigIntErrorDomain";

@implementation BigIntError

+ (NSString *)domain {
    return BigIntErrorDomain;
}

+ (NSError *)emptyStringNumber {
    NSDictionary *errorInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not initialize number; set to default (=0) value.", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The string-number should not be empty or zero-sized.", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the string contains at least one digit.", nil)
        };
    return [NSError errorWithDomain:BigIntErrorDomain
                               code:BIEC_EmptyStringNumber
                           userInfo:errorInfo];
}

+ (NSError *)invalidBaseNumber {
    NSDictionary *errorInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not initialize number; set to default (=0) value.", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The base-number is invalid.", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure the base-number is 0 or between 2 and 62.", nil)
        };
    return [NSError errorWithDomain:BigIntErrorDomain
                               code:BIEC_InvalidBaseNumber
                           userInfo:errorInfo];
}

+ (NSError *)invalidNumberFormat {
    NSDictionary *errorInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not initialize number.", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The string-number is not a valid number-format for the current base.", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check that the number contains ONLY digits {0,..,9} for base <= 10 or 'digits' {A,..,Z,a,..,z} for 10 < base < 63.", nil)
        };
    return [NSError errorWithDomain:BigIntErrorDomain
                               code:BIEC_InvalidNumberFormat
                           userInfo:errorInfo];
}

@end
