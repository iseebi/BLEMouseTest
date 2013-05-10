//
//  ESBLEHIDDescriptor.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ESBLEHIDDescriptorUsageTag = 0x09,
    ESBLEHIDDescriptorUsagePageTag = 0x05,
    ESBLEHIDDescriptorUsageMinimumTag = 0x19,
    ESBLEHIDDescriptorUsageMaximumTag = 0x29,
    ESBLEHIDDescriptorDesignatorIndexTag = 0x39,
    ESBLEHIDDescriptorDesignatorMinimumTag = 0x49,
    ESBLEHIDDescriptorDesignatorMaximumTag = 0x59,
    ESBLEHIDDescriptorStringIndexTag = 0x69,
    ESBLEHIDDescriptorStringMinimumTag = 0x79,
    ESBLEHIDDescriptorStringMaximumTag = 0x89,
    ESBLEHIDDescriptorCollectionTag = 0xA1,
    ESBLEHIDDescriptorEndCollectionTag = 0xC0,
    ESBLEHIDDescriptorInputTag = 0x81,
    ESBLEHIDDescriptorOutputTag = 0x91,
    ESBLEHIDDescriptorFeatureTag = 0xB1,
    ESBLEHIDDescriptorLogicalMimimumTag = 0x15,
    ESBLEHIDDescriptorLogicalMaximumTag = 0x25,
    ESBLEHIDDescriptorPhysicalMimimumTag = 0x35,
    ESBLEHIDDescriptorPhysicalMaximumTag = 0x45,
    ESBLEHIDDescriptorUnitExponentTag = 0x55,
    ESBLEHIDDescriptorUnitTag = 0x65,
    ESBLEHIDDescriptorReportSizeTag = 0x75,
    ESBLEHIDDescriptorReportIDTag = 0x85,
    ESBLEHIDDescriptorReportCountTag = 0x95,
    ESBLEHIDDescriptorPushTag = 0xA4,
    ESBLEHIDDescriptorPopTag = 0xB4,
    ESBLEHIDDescriptorDelimiterTag = 0xA9
} typedef ESBLEHIDDescriptorTag;

enum {
    ESBLEHIDDescriptorTypeUnknown,
    ESBLEHIDDescriptorTypeMain,
    ESBLEHIDDescriptorTypeGlobal,
    ESBLEHIDDescriptorTypeLocal,
} typedef ESBLEHIDDescriptorType;

enum  {
    ESBLEHIDUsagePageUndefined = 0x00,
    ESBLEHIDUsagePageGenericDesktopControls = 0x01,
    ESBLEHIDUsagePageSimulationControls = 0x02,
    ESBLEHIDUsagePageVRControls = 0x03,
    ESBLEHIDUsagePageSportControls = 0x04,
    ESBLEHIDUsagePageGameControls = 0x05,
    ESBLEHIDUsagePageGenericDeviceControls = 0x06,
    ESBLEHIDUsagePageKeyboard = 0x07,
    ESBLEHIDUsagePageLEDs = 0x08,
    ESBLEHIDUsagePageButton = 0x09,
    ESBLEHIDUsagePageOrdinal = 0x0A,
} typedef ESBLEHIDDescriptorUsagePages;

enum  {
    ESBLEHIDUsagePointer = 0x01,
    ESBLEHIDUsageMouse = 0x02,
    ESBLEHIDUsageKeyboard = 0x07,
    ESBLEHIDUsageKeypad = 0x07,
    ESBLEHIDUsageMultiAxisController = 0x08,
    ESBLEHIDUsageX = 0x30,
    ESBLEHIDUsageY = 0x31,
    ESBLEHIDUsageZ = 0x32,
    ESBLEHIDUsageRx = 0x33,
    ESBLEHIDUsageRy = 0x34,
    ESBLEHIDUsageRz = 0x35,
    ESBLEHIDUsageSlider = 0x36,
    ESBLEHIDUsageDial = 0x37,
    ESBLEHIDUsageWheel = 0x38,
    ESBLEHIDUsageHatSwitch = 0x39,
} typedef ESBLEHIDDescriptorGenericDesktopUsages;

enum {
    ESBLEHIDUsageButton1 = 0x01,
    ESBLEHIDUsageButton2 = 0x02,
    ESBLEHIDUsageButton3 = 0x03,
    ESBLEHIDUsageButton4 = 0x04,
    ESBLEHIDUsageButton5 = 0x05,
    
    ESBLEHIDUsagePrimaryButton = 0x01,
    ESBLEHIDUsageSecondaryButton = 0x02,
    ESBLEHIDUsageWheelButton = 0x03,
} typedef ESBLEHIDDescriptorButtonUsages;

extern NSString *const ESBLEHIDDescriptorUsageKey;
extern NSString *const ESBLEHIDDescriptorUsagePageKey;
extern NSString *const ESBLEHIDDescriptorUsageMinimumKey;
extern NSString *const ESBLEHIDDescriptorUsageMaximumKey;
extern NSString *const ESBLEHIDDescriptorDesignatorIndexKey;
extern NSString *const ESBLEHIDDescriptorDesignatorMinimumKey;
extern NSString *const ESBLEHIDDescriptorDesignatorMaximumKey;
extern NSString *const ESBLEHIDDescriptorStringIndexKey;
extern NSString *const ESBLEHIDDescriptorStringMinimumKey;
extern NSString *const ESBLEHIDDescriptorStringMaximumKey;
extern NSString *const ESBLEHIDDescriptorCollectionKey;
extern NSString *const ESBLEHIDDescriptorEndCollectionKey;
extern NSString *const ESBLEHIDDescriptorInputKey;
extern NSString *const ESBLEHIDDescriptorOutputKey;
extern NSString *const ESBLEHIDDescriptorFeatureKey;
extern NSString *const ESBLEHIDDescriptorLogicalMimimumKey;
extern NSString *const ESBLEHIDDescriptorLogicalMaximumKey;
extern NSString *const ESBLEHIDDescriptorPhysicalMimimumKey;
extern NSString *const ESBLEHIDDescriptorPhysicalMaximumKey;
extern NSString *const ESBLEHIDDescriptorUnitExponentKey;
extern NSString *const ESBLEHIDDescriptorUnitKey;
extern NSString *const ESBLEHIDDescriptorReportSizeKey;
extern NSString *const ESBLEHIDDescriptorReportIDKey;
extern NSString *const ESBLEHIDDescriptorReportCountKey;
extern NSString *const ESBLEHIDDescriptorPushKey;
extern NSString *const ESBLEHIDDescriptorPopKey;
extern NSString *const ESBLEHIDDescriptorDelimiterKey;

@interface ESBLEHIDDescriptor : NSObject

@property (readonly, assign, nonatomic) ESBLEHIDDescriptorTag tag;
@property (readonly, assign, nonatomic) ESBLEHIDDescriptorType type;
@property (readonly, copy, nonatomic) NSData *data;
@property (readonly, assign, nonatomic) NSUInteger length;

+ (id) HIDDescriptorWithData:(NSData *)data offset:(NSUInteger)offset;
- (id) initWithTag:(ESBLEHIDDescriptorTag)tag data:(NSData *)data;
- (id) initWithTag:(ESBLEHIDDescriptorTag)tag data:(NSData *)data length:(NSUInteger)length;

+ (NSString *)descriptorDictionaryKeyFromTag:(ESBLEHIDDescriptorTag)tag;

@end
