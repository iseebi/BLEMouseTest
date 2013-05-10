//
//  ESBLEHIDDataObject.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESBLEHIDDescriptor.h"

@interface ESBLEHIDDataObject : NSObject

@property (readonly, strong, nonatomic) ESBLEHIDDescriptor *descriptorMainItem;
@property (readonly, copy, nonatomic) NSDictionary *descriptorItems;

+ (id)dataFieldWithMainItemDescriptor:(ESBLEHIDDescriptor *)descriptor
                          globalItems:(NSDictionary *)globalItems
                           localItems:(NSDictionary *)localItems;
+ (id)dataFieldWithMainItemDescriptor:(ESBLEHIDDescriptor *)descriptor
                                items:(NSDictionary *)items;

- (id)initWithMainDescriptor:(ESBLEHIDDescriptor *)descriptor
             descriptorItems:(NSDictionary *)items;

- (BOOL)hasUsage;

- (NSUInteger)usage;
- (NSUInteger)usagePage;

- (NSUInteger)usageCount;
- (NSUInteger)usageAtIndex:(NSUInteger)index;

@end
