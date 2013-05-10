//
//  ESBLEHIDDescriptorParser.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESBLEHIDDescriptor.h"
#import "ESBLEHIDDataField.h"

@interface ESBLEHIDDescriptorParser : NSObject

+ (NSArray *)descriptorsWithData:(NSData *)data;

@end
