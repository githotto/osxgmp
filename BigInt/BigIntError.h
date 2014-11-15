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
