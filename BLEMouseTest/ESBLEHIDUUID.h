//
//  ESBLEHIDUUID.h
//  BLEMouseTest
//
//  Created by 伊藤 伸裕 on 2013/07/20.
//  Copyright (c) 2013年 伊藤 伸裕. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString * const ESBLEUUIDServiceHumanInterfaceDeviceString;
extern NSString * const ESBLEUUIDCharacteristicHIDInformationString;
extern NSString * const ESBLEUUIDCharacteristicReportMapString;
extern NSString * const ESBLEUUIDCharacteristicBootMouseInputReportString;
extern NSString * const ESBLEUUIDCharacteristicReportString;
extern NSString * const ESBLEUUIDCharacteristicHIDControlPointString;
extern NSString * const ESBLEUUIDCharacteristicProtocolModeString;

@interface ESBLEHIDUUID : NSObject

@property (readonly, strong, nonatomic) CBUUID *HIDServiceUUID;
@property (readonly, strong, nonatomic) CBUUID *HIDInformationCharacterisiticUUID;
@property (readonly, strong, nonatomic) CBUUID *reportMapCharacterisiticUUID;
@property (readonly, strong, nonatomic) CBUUID *bootMouseInputReportCharacterisitcUUID;
@property (readonly, strong, nonatomic) CBUUID *reportCharacterisitcUUID;
@property (readonly, strong, nonatomic) CBUUID *HIDControlPointCharacterisitcUUID;
@property (readonly, strong, nonatomic) CBUUID *protocolModeCharacterisitcUUID;

+ (ESBLEHIDUUID *)sharedInstance;

@end
