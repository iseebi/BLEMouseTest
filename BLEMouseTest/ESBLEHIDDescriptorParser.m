//
//  ESBLEHIDDescriptorParser.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDescriptorParser.h"

@implementation ESBLEHIDDescriptorParser

//--------------------------------------------------------------------------------------------------
#pragma mark - Descriptor Parse
//--------------------------------------------------------------------------------------------------

+ (NSArray *)descriptorsWithData:(NSData *)data
{
    NSMutableArray *descriptors = [NSMutableArray array];
    int offset = 0;
    while (offset < [data length]) {
        ESBLEHIDDescriptor *descriptor = [ESBLEHIDDescriptor HIDDescriptorWithData:data offset:offset];
        NSUInteger length = [self appendDescriptor:descriptor toMutableArray:descriptors];
        if (length > 0) {
            offset += length;
        }
        else {
            // エラー
            return nil;
        }
    }
    return descriptors;
}

+ (NSUInteger)appendDescriptor:(ESBLEHIDDescriptor *)descriptor toMutableArray:(NSMutableArray *)descriptors {
    if (descriptor != nil) {
        [descriptors addObject:descriptor];
        return descriptor.length;
    }
    else {
        // エラー
        return 0;
    }
}

@end
