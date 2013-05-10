//
//  ESBLEHIDUUID.m
//  BLEMouseTest
//
//  Created by 伊藤 伸裕 on 2013/07/20.
//  Copyright (c) 2013年 伊藤 伸裕. All rights reserved.
//

#import "ESBLEHIDUUID.h"

NSString * const ESBLEUUIDServiceHumanInterfaceDeviceString = @"1812";
NSString * const ESBLEUUIDCharacteristicHIDInformationString = @"2A4A";
NSString * const ESBLEUUIDCharacteristicReportMapString = @"2A4B";
NSString * const ESBLEUUIDCharacteristicBootMouseInputReportString = @"2A33";
NSString * const ESBLEUUIDCharacteristicReportString = @"2A4D";
NSString * const ESBLEUUIDCharacteristicHIDControlPointString = @"2A4C";
NSString * const ESBLEUUIDCharacteristicProtocolModeString = @"2A4E";

@interface ESBLEHIDUUID ()

@end

@implementation ESBLEHIDUUID

//--------------------------------------------------------------------------------------------------
#pragma mark - Singleton
//--------------------------------------------------------------------------------------------------

static ESBLEHIDUUID *_sharedInstance = nil;

+ (ESBLEHIDUUID *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ESBLEHIDUUID alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _HIDServiceUUID = [CBUUID UUIDWithString:ESBLEUUIDServiceHumanInterfaceDeviceString];
        _HIDInformationCharacterisiticUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicHIDInformationString];
        _reportMapCharacterisiticUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicReportMapString];
        _bootMouseInputReportCharacterisitcUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicBootMouseInputReportString];
        _reportCharacterisitcUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicReportString];
        _HIDControlPointCharacterisitcUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicHIDControlPointString];
        _protocolModeCharacterisitcUUID = [CBUUID UUIDWithString:ESBLEUUIDCharacteristicProtocolModeString];
    }
    return self;
}

@end
