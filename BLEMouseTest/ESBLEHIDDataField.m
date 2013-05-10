//
//  ESBLEHIDDataField.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataField.h"

#import "NSData+ESBLEHIDAddition.h"

@interface ESBLEHIDDataField ()

@property (assign, nonatomic) NSInteger usageMin;
@property (assign, nonatomic) NSInteger usageMax;
@property (copy, nonatomic) NSArray *usageMap;
@property (strong, nonatomic) NSMutableData *buffer;

@end

@implementation ESBLEHIDDataField

//--------------------------------------------------------------------------------------------------
#pragma mark - Convinience Methods
//--------------------------------------------------------------------------------------------------

+ (id)dataFieldWithMainItemDescriptor:(ESBLEHIDDescriptor *)descriptor
                                items:(NSDictionary *)items
{
    ESBLEHIDDataFieldType type;
    switch (descriptor.tag) {
        case ESBLEHIDDescriptorInputTag:
            type = ESBLEHIDDataFieldInput;
            break;
        case ESBLEHIDDescriptorOutputTag:
            type = ESBLEHIDDataFieldOutput;
            break;
        case ESBLEHIDDescriptorFeatureTag:
            type = ESBLEHIDDataFieldFeature;
            break;
        default:
            return nil;
    }
    
    NSData *reportCountData = items[ESBLEHIDDescriptorReportCountKey];
    NSData *reportSizeData = items[ESBLEHIDDescriptorReportSizeKey];
    if ([reportCountData isKindOfClass:[NSData class]] && [reportSizeData isKindOfClass:[NSData class]]) {
        NSUInteger reportCount = [reportCountData ESBLEHID_unsignedIntegerValue];
        NSUInteger reportSize = [reportSizeData ESBLEHID_unsignedIntegerValue];
        return [[self alloc] initWithMainDescriptor:descriptor
                                         fieldCount:reportCount
                                          fieldSize:reportSize
                                    descriptorItems:items];
    }
    else {
        return nil;
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Initialize / Deallocating
//--------------------------------------------------------------------------------------------------

- (id)initWithMainDescriptor:(ESBLEHIDDescriptor *)descriptor
                  fieldCount:(NSUInteger)count
                   fieldSize:(NSUInteger)size
             descriptorItems:(NSDictionary *)items
{
    self = [super initWithMainDescriptor:descriptor descriptorItems:items];
    if (self) {
        switch (descriptor.tag) {
            case ESBLEHIDDescriptorInputTag:
                _type = ESBLEHIDDataFieldInput;
                break;
            case ESBLEHIDDescriptorOutputTag:
                _type = ESBLEHIDDataFieldOutput;
                break;
            case ESBLEHIDDescriptorFeatureTag:
                _type = ESBLEHIDDataFieldFeature;
                break;
            default:
                break;
        }
        _fieldCount = count;
        _fieldSize = size;
        
        if (self.fieldSize >= 8) {
            self.buffer = [NSMutableData dataWithCapacity:(self.fieldSize / 8)];
            [self.buffer setLength:(self.fieldSize / 8)];
        }
        else {
            self.buffer = [NSMutableData dataWithCapacity:1];
            [self.buffer setLength:1];
        }
        
        if ([items objectForKey:ESBLEHIDDescriptorUsageKey] != nil) {
            // USAGE only patten
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[items count]];
            for (int i = 0; i < [items[ESBLEHIDDescriptorUsageKey] count]; i++) {
                NSData *itemData = items[ESBLEHIDDescriptorUsageKey][i];
                NSUInteger itemValue = [itemData ESBLEHID_unsignedIntegerValue];
                [array addObject:[NSNumber numberWithUnsignedInteger:itemValue]];
            }
            self.usageMap = array;
        }
        else if (([items objectForKey:ESBLEHIDDescriptorUsageMinimumKey] != nil)
                 && ([items objectForKey:ESBLEHIDDescriptorUsageMaximumKey] != nil))
        {
            // USAGE_MINIMUM - USAGE_MAXUMIM pattern
            self.usageMin = [items[ESBLEHIDDescriptorUsageMinimumKey]
                             ESBLEHID_unsignedIntegerValue];
            self.usageMax = [items[ESBLEHIDDescriptorUsageMaximumKey]
                             ESBLEHID_unsignedIntegerValue];
        }
        else {
            // no usage
        }
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Read values
//--------------------------------------------------------------------------------------------------

- (void)readDataToBufferAtIndex:(NSUInteger)index
{
    NSInteger offset = self.offset + (index * self.fieldSize);
    NSInteger byteOffset = offset / 8;
    NSInteger bitOffset = offset - (byteOffset * 8);
    
    // TODO: fieldSize が 8未満か、バイト刻みであることしか想定されていない。
    // TODO: 8ビット以上のバイト刻みになってる時は、ビット刻みのオフセットを考慮できない。
    
    if (self.fieldSize >= 8) {
        if (bitOffset == 0) {
            NSUInteger byteLength = self.fieldSize / 8;
            memmove((void *)[self.buffer bytes], [self.data bytes] + byteOffset, byteLength);
            [self.buffer ESBLEHID_endianConvert];
        }
        else {
            // 8ビット以上のバイト刻みになってる時は、ビット刻みのオフセットを考慮できない。
            NSLog(@"Cannot process bit order!");
        }
    }
    else {
        Byte *value = (Byte *)[self.buffer bytes];
        Byte mask = 0;
        memmove(value, [self.data bytes] + byteOffset, sizeof(*value));
        for (int i = 0 ; i < self.fieldSize; i++) {
            mask |= 1 << (i + bitOffset);
        }
        *value &= mask;
        *value = *value >> bitOffset;
    }
}

- (NSInteger)integerValueAtIndex:(NSUInteger)index
{
    [self readDataToBufferAtIndex:index];
    NSInteger val = 0;
    NSInteger byteSize = (self.fieldSize / 8);
    if (byteSize == sizeof(NSInteger)) {
        val = [self.buffer ESBLEHID_integerValue];
    }
    else if (byteSize == sizeof(short)) {
        val = [self.buffer ESBLEHID_shortValue];
    }
    else {
        val = [self.buffer ESBLEHID_integerValue];
    }
    return val;
}

- (NSUInteger)unsignedIntegerValueAtIndex:(NSUInteger)index;
{
    [self readDataToBufferAtIndex:index];
    return [self.buffer ESBLEHID_unsignedIntegerValue];
}

- (BOOL)boolValueAtIndex:(NSUInteger)index
{
    [self readDataToBufferAtIndex:index];
    Byte *value = (Byte *) [self.buffer bytes];
    return (*value) != 0;
}

- (NSUInteger)usageAtIndex:(NSUInteger)index
{
    if (self.usageMap != nil) {
        return [self.usageMap[index] unsignedIntegerValue];
    }
    else if ((self.usageMin > 0) && (self.usageMax > 0)) {
        return self.usageMin + index;
    }
    else {
        return 0;
    }
}

- (NSUInteger)usageCount
{
    return self.fieldCount;
}

- (NSUInteger) length
{
    return self.fieldCount * self.fieldSize;
}


@end
