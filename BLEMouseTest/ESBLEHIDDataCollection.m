//
//  ESBLEHIDDataCollection.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataCollection.h"

@interface ESBLEHIDDataCollection ()

@property (strong, nonatomic) NSMutableArray *mutableChildrenCollection;
@property (strong, nonatomic) NSMutableArray *mutableChildrenDataField;

@end

@implementation ESBLEHIDDataCollection

//--------------------------------------------------------------------------------------------------
#pragma mark - Initialize / Deallocating
//--------------------------------------------------------------------------------------------------

-(id)initWithMainDescriptor:(ESBLEHIDDescriptor *)descriptor descriptorItems:(NSDictionary *)items
{
    self = [super initWithMainDescriptor:descriptor descriptorItems:items];
    if (self) {
        self.mutableChildrenCollection = [NSMutableArray array];
        self.mutableChildrenDataField = [NSMutableArray array];
        _childrenCollection = self.mutableChildrenCollection;
        _childrenDataField = self.mutableChildrenDataField;
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Add items
//--------------------------------------------------------------------------------------------------

- (void)addDataField:(ESBLEHIDDataField *)dataField
{
    [self.mutableChildrenDataField addObject:dataField];
}

- (void)addCollection:(ESBLEHIDDataCollection *)collection
{
    [self.mutableChildrenCollection addObject:collection];
}

@end
