//
//  ESBLEHIDDevice.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDevice.h"

@implementation ESBLEHIDDevice

+ (id) deviceWithDataTree:(ESBLEHIDDataTree *)tree
{
    return nil;
}

- (id) initWithDataCollection:(ESBLEHIDDataCollection *)collection
{
    self = [super init];
    if (self) {
        _dataCollection = collection;
    }
    return self;
}

-(void)reportValueUpdated
{
}

@end
