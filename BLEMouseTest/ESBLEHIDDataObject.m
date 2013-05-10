//
//  ESBLEHIDDataObject.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataObject.h"
#import "NSData+ESBLEHIDAddition.h"

@implementation ESBLEHIDDataObject

//--------------------------------------------------------------------------------------------------
#pragma mark - Convinience Methods
//--------------------------------------------------------------------------------------------------

+ (id)dataFieldWithMainItemDescriptor:(ESBLEHIDDescriptor *)descriptor
                            globalItems:(NSDictionary *)globalItems
                             localItems:(NSDictionary *)localItems
{
    NSMutableDictionary *items = [NSMutableDictionary dictionary];
    [items addEntriesFromDictionary:globalItems];
    [items addEntriesFromDictionary:localItems];
    
    return [self dataFieldWithMainItemDescriptor:descriptor items:items];
}

+ (id)dataFieldWithMainItemDescriptor:(ESBLEHIDDescriptor *)descriptor
                                items:(NSDictionary *)items
{
    return [[self alloc] initWithMainDescriptor:descriptor descriptorItems:items];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Initialize / Deallocating
//--------------------------------------------------------------------------------------------------

- (id)initWithMainDescriptor:(ESBLEHIDDescriptor *)descriptor
             descriptorItems:(NSDictionary *)items
{
    self = [super init];
    if (self) {
        _descriptorMainItem = descriptor;
        _descriptorItems = items;
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Read descriptor item value
//--------------------------------------------------------------------------------------------------

- (NSUInteger)descriptorItemUnsignedIntegerValueForKey:(NSString *)key index:(NSUInteger)index
{
    if ([self.descriptorItems objectForKey:key]) {
        if ([self.descriptorItems[key] isKindOfClass:[NSArray class]]) {
            return [self.descriptorItems[key][index] ESBLEHID_unsignedIntegerValue];
        }
        else {
            return [self.descriptorItems[key] ESBLEHID_unsignedIntegerValue];
        }
    }
    else {
        return 0;
    }
}

- (NSUInteger)usage
{
    return [self usageAtIndex:0];
}

- (NSUInteger)usageCount
{
    return [self.descriptorItems[ESBLEHIDDescriptorUsageKey] count];
}

- (NSUInteger)usageAtIndex:(NSUInteger)index
{
    return [self descriptorItemUnsignedIntegerValueForKey:ESBLEHIDDescriptorUsageKey index:index];
}

- (NSUInteger)usagePage
{
    return [self descriptorItemUnsignedIntegerValueForKey:ESBLEHIDDescriptorUsagePageKey index:0];
}

-(BOOL)hasUsage
{
    if ((self.descriptorItems[ESBLEHIDDescriptorUsageKey] != nil) ||
        ((self.descriptorItems[ESBLEHIDDescriptorUsageMinimumKey] != nil) && (self.descriptorItems[ESBLEHIDDescriptorUsageMaximumKey] != nil)))
    {
        return YES;
    }
    else {
        return NO;
    }
    
}

@end
