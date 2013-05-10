//
//  ESBLEHIDDataTree.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ESBLEHIDDataObject.h"
#import "ESBLEHIDDataCollection.h"
#import "ESBLEHIDDataField.h"

#import "ESBLEHIDDescriptor.h"

@interface ESBLEHIDDataTree : NSObject

@property (strong, nonatomic, readonly) ESBLEHIDDataCollection *rootCollection;

- (id)initWithDescriptorArray:(NSArray *)descriptors;

- (ESBLEHIDDataCollection *)findDeviceWithUsageID:(NSUInteger)usageID;

- (void)writeReportData:(NSData *)data;

@end
