//
//  ESBLEHIDDriver.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDriver.h"
#import "ESBLEHIDDescriptorParser.h"
#import "ESBLEHIDDataTree.h"
#import "ESBLEHIDUUID.h"

@interface ESBLEHIDDriver ()

@property (strong, nonatomic) CBService *HIDService;
@property (strong, nonatomic) CBCharacteristic *HIDInformationCharacterisitic;
@property (strong, nonatomic) CBCharacteristic *reportMapCharacterisitic;
@property (strong, nonatomic) CBCharacteristic *bootMouseInputReportCharacterisitc;
@property (strong, nonatomic) CBCharacteristic *reportReadCharacterisitc;
@property (strong, nonatomic) CBCharacteristic *reportWriteCharacterisitc;
@property (strong, nonatomic) CBCharacteristic *HIDControlPointCharacterisitc;
@property (strong, nonatomic) CBCharacteristic *protocolModeCharacterisitc;

@property (strong, nonatomic) NSArray *reportMap;
@property (strong, nonatomic) NSMutableArray *reportDevices;

@end

@implementation ESBLEHIDDriver

//--------------------------------------------------------------------------------------------------
#pragma mark - Initialize / Deallocating
//--------------------------------------------------------------------------------------------------

- (id) initWithPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _deviceType = ESBLEHIDDeviceTypeUnknown;
        
        self.peripehral = peripheral;
        self.peripehral.delegate = self;
        
        self.reportDevices = [NSMutableArray array];
        
        [self discoverService];
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Discover
//--------------------------------------------------------------------------------------------------

- (void)discoverService
{
    [self.peripehral discoverServices:@[[ESBLEHIDUUID sharedInstance].HIDServiceUUID]];
}

- (void)discoverCharacterisitics
{
    [self.peripehral discoverCharacteristics:@[
     [ESBLEHIDUUID sharedInstance].HIDInformationCharacterisiticUUID,
     [ESBLEHIDUUID sharedInstance].reportMapCharacterisiticUUID,
     [ESBLEHIDUUID sharedInstance].bootMouseInputReportCharacterisitcUUID,
     [ESBLEHIDUUID sharedInstance].reportCharacterisitcUUID,
     [ESBLEHIDUUID sharedInstance].HIDControlPointCharacterisitcUUID,
     [ESBLEHIDUUID sharedInstance].protocolModeCharacterisitcUUID
     ] forService:self.HIDService];
}

- (void)readReportMap
{
    [self.peripehral readValueForCharacteristic:self.reportMapCharacterisitic];
}

- (void)parseReportMapWithData:(NSData *)data
{
    self.reportMap = [ESBLEHIDDescriptorParser descriptorsWithData:data];
    self.dataTree = [[ESBLEHIDDataTree alloc] initWithDescriptorArray:self.reportMap];
    [self.delegate HIDDriverDataTreeCreated:self];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Device manage
//--------------------------------------------------------------------------------------------------

- (void)addDeviceForReport:(ESBLEHIDDevice *)device
{
    [self.reportDevices addObject:device];
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Read Value
//--------------------------------------------------------------------------------------------------

- (void)listenReport {
    [self.peripehral setNotifyValue:YES forCharacteristic:self.reportReadCharacterisitc];
}

- (void)receiveReportWithData:(NSData *)data
{
    [self.dataTree writeReportData:data];
    if ([self.delegate respondsToSelector:@selector(HIDDriverReportedValue:)]) {
        [self.delegate HIDDriverReportedValue:self];
    }
    for (ESBLEHIDDevice *device in self.reportDevices) {
        [device reportValueUpdated];
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - CBPeripheralDelegate
//--------------------------------------------------------------------------------------------------

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    for (CBService *service in self.peripehral.services) {
        if ([service.UUID isEqual:[ESBLEHIDUUID sharedInstance].HIDServiceUUID]) {
            NSLog(@"Received HID Service! : %@", service);
            self.HIDService = service;
            [self discoverCharacterisitics];
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service isEqual:self.HIDService]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].HIDInformationCharacterisiticUUID]) {
                self.HIDInformationCharacterisitic = characteristic;
            }
            else if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].reportMapCharacterisiticUUID]) {
                self.reportMapCharacterisitic = characteristic;
            }
            else if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].bootMouseInputReportCharacterisitcUUID]) {
                self.bootMouseInputReportCharacterisitc = characteristic;
            }
            else if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].reportCharacterisitcUUID]) {
                if (characteristic.properties & CBCharacteristicPropertyNotify) {
                    self.reportReadCharacterisitc = characteristic;
                }
                else {
                    self.reportWriteCharacterisitc = characteristic;
                }
            }
            else if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].HIDControlPointCharacterisitcUUID]) {
                self.HIDControlPointCharacterisitc = characteristic;
            }
            else if ([characteristic.UUID isEqual:[ESBLEHIDUUID sharedInstance].protocolModeCharacterisitcUUID]) {
                self.protocolModeCharacterisitc = characteristic;
            }
            else {
                NSLog(@"Unknown UUID detected: %@", characteristic.UUID);
            }
        }
        // 規格的にはReportMapとHID Control Pointのみが必須で、あとは状況によりけり。
        if ((self.HIDControlPointCharacterisitc != nil) && (self.reportMapCharacterisitic != nil)) {
            // TODO: Descriptor の取得もやったほうがいいの？
            [self readReportMap];
        }
        else {
            // TODO: エラーのデリゲートを叩く
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic isEqual:self.reportMapCharacterisitic]) {
        NSLog(@"%s: Received report map: %@", __PRETTY_FUNCTION__, characteristic.value);
        [self parseReportMapWithData:characteristic.value];
        [self listenReport];
    }
    else if ([characteristic isEqual:self.reportReadCharacterisitc]) {
        //NSLog(@"%s: Received report %@", __PRETTY_FUNCTION__, characteristic.value);
        [self receiveReportWithData:characteristic.value];
    }
    else {
        NSLog(@"%s: Unknown characteristic value received: %@", __PRETTY_FUNCTION__, characteristic);
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic isEqual:self.reportReadCharacterisitc]) {
        NSLog(@"%s: %@", __PRETTY_FUNCTION__, characteristic.value);
    }
}


@end
