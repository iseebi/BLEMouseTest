//
//  ESBLEHIDDriver.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "ESBLEHIDDataTree.h"
#import "ESBLEHIDDevice.h"

enum {
    ESBLEHIDDeviceTypeUnknown,
    ESBLEHIDDeviceTypeMouse,
    ESBLEHIDDeviceTypeKeyboard,
} typedef ESBLEHIDDeviceType;

@class ESBLEHIDDriver;

@protocol ESBLEHIDDriverDelegate <NSObject>

- (void)HIDDriverDataTreeCreated:(ESBLEHIDDriver *)driver;

@optional

- (void)HIDDriverReportedValue:(ESBLEHIDDriver *)driver;

@end

@interface ESBLEHIDDriver : NSObject <CBPeripheralDelegate>

@property (weak, nonatomic) id<ESBLEHIDDriverDelegate> delegate;

@property (strong, nonatomic) CBPeripheral *peripehral;
@property (readonly, assign, nonatomic) ESBLEHIDDeviceType deviceType;

@property (strong, nonatomic) ESBLEHIDDataTree *dataTree;

- (id) initWithPeripheral:(CBPeripheral *)peripheral;

- (void) addDeviceForReport:(ESBLEHIDDevice *)device;

@end
