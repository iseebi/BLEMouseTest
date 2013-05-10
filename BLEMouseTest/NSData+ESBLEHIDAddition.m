//
//  NSData+ESBLEHIDAddition.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "NSData+ESBLEHIDAddition.h"

@implementation NSData(ESBLEHIDAddition)

-(NSData *)ESBLEHID_dataWithEndianConvert
{
    if ([self length] > 1) {
        NSMutableData *newData = [NSMutableData dataWithCapacity:[self length]];
        for (int i = ([self length] - 1); i >= 0; i--) {
            [newData appendData:[self subdataWithRange:NSMakeRange(i, 1)]];
        }
        return newData;
    }
    else {
        return [self copy];
    }
}

- (short)ESBLEHID_shortValue
{
    short value = 0;
    if (sizeof(value) > [self length]) {
        [self getBytes:&value length:[self length]];
    }
    else {
        [self getBytes:&value length:sizeof(value)];
    }
    return value;
}

- (NSInteger)ESBLEHID_integerValue
{
    NSInteger value = 0;
    if (sizeof(value) > [self length]) {
        [self getBytes:&value length:[self length]];
    }
    else {
        [self getBytes:&value length:sizeof(value)];
    }
    return value;
}

- (NSUInteger)ESBLEHID_unsignedIntegerValue
{
    NSUInteger value = 0;
    if (sizeof(value) > [self length]) {
        [self getBytes:&value length:[self length]];
    }
    else {
        [self getBytes:&value length:sizeof(value)];
    }
    return value;
}

@end

@implementation NSMutableData(ESBLEHIDAddition)

- (void)ESBLEHID_endianConvert
{
    NSUInteger length = [self length];
    if (length > 1) {
        Byte *ptr = (Byte *)[self bytes];
//        Byte top = (*ptr >> 8) & 0x0f;
//        Byte btm = (*ptr << 8) & 0xf0;
//        *ptr = btm | top;
        for (int i = 0; i < (length / 2); i++) {
            Byte temp = ptr[i];
            ptr[i] = ptr[length - 1 - i];
            ptr[length - 1 - i] = temp;
        }
    }
}

@end
