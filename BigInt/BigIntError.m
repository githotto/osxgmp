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
