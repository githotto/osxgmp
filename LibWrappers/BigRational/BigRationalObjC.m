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
//  BigRationalObjC.m
//  BigNumber
//
//  Created by Otto van Verseveld on 10/26/14.
//  Copyright (c) 2014 Otto van Verseveld. All rights reserved.
//

#import "BigRationalObjC.h"

@implementation BigRationalObjC


#pragma mark - Initialization / removal
- (void)dealloc {
//    NSLog(@"Calling dealloc and mpq_clear ...");
    mpq_clear(bigRational);
}


#pragma mark - GMP Paragraph 6.1 Initialization and Assignment Functions
- (id)init {
    self = [super init];
    mpq_init(bigRational);
    return self;
}

- (void)clear {
    mpq_clear(bigRational);
}

@end
