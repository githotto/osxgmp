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
//  BigIntError.h
//  BigNumber
//
//  Created by Otto van Verseveld on 10/17/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const BigIntErrorDomain;

typedef enum BigIntErrorCode {
    BIEC_Undefined = 0,
    BIEC_EmptyStringNumber,
    BIEC_InvalidBaseNumber,
    BIEC_InvalidNumberFormat,
    BIEC_Other
} BigIntErrorCode;


@interface BigIntError : NSObject

+ (NSError *)emptyStringNumber;

+ (NSError *)invalidBaseNumber;

+ (NSError *)invalidNumberFormat;

@end
