//
//  ESBLEHIDDataField.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataObject.h"

@class ESBLEHIDDescriptor;

enum {
    ESBLEHIDDataFieldInput,
    ESBLEHIDDataFieldOutput,
    ESBLEHIDDataFieldFeature,
} typedef ESBLEHIDDataFieldType;

#define ESBLEHIDDataFieldNotDefined INT_MIN

@interface ESBLEHIDDataField : ESBLEHIDDataObject

@property (readonly, assign, nonatomic) ESBLEHIDDataFieldType type;
@property (readonly, assign, nonatomic) NSUInteger fieldCount;
@property (readonly, assign, nonatomic) NSUInteger fieldSize;
@property (readonly, assign, nonatomic) NSUInteger length;

@property (weak, nonatomic) NSData *data;
@property (assign, nonatomic) NSUInteger offset;

- (id)initWithMainDescriptor:(ESBLEHIDDescriptor *)descriptor
                  fieldCount:(NSUInteger)count
                   fieldSize:(NSUInteger)size
             descriptorItems:(NSDictionary *)items;

- (NSInteger)integerValueAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntegerValueAtIndex:(NSUInteger)index;
- (BOOL)boolValueAtIndex:(NSUInteger)index;

@end
