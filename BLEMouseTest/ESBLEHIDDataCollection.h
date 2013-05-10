//
//  ESBLEHIDDataCollection.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataObject.h"

@class ESBLEHIDDataField;

@interface ESBLEHIDDataCollection : ESBLEHIDDataObject

@property (strong, readonly, nonatomic) NSArray *childrenCollection;
@property (strong, readonly, nonatomic) NSArray *childrenDataField;

- (void)addDataField:(ESBLEHIDDataField *)dataField;
- (void)addCollection:(ESBLEHIDDataCollection *)collection;

@end
