//
//  ESBLEHIDDevice.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESBLEHIDDataCollection.h"
#import "ESBLEHIDDataField.h"

#import "ESBLEHIDDataTree.h"

@class ESBLEHIDDataTree;

@interface ESBLEHIDDevice : NSObject

@property (readonly, strong, nonatomic) ESBLEHIDDataCollection *dataCollection;

+ (id) deviceWithDataTree:(ESBLEHIDDataTree *)tree;

- (id) initWithDataCollection:(ESBLEHIDDataCollection *)collection;
- (void)reportValueUpdated;

@end
