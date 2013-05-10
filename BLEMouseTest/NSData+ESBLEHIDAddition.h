//
//  NSData+ESBLEHIDAddition.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(ESBLEHIDAddition)

- (NSData *)ESBLEHID_dataWithEndianConvert;
- (short)ESBLEHID_shortValue;
- (NSInteger)ESBLEHID_integerValue;
- (NSUInteger)ESBLEHID_unsignedIntegerValue;

@end

@interface NSMutableData(ESBLEHIDAddition)

- (void)ESBLEHID_endianConvert;

@end
