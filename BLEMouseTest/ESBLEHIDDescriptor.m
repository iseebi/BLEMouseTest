//
//  ESBLEHIDDescriptor.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDescriptor.h"
#import "NSData+ESBLEHIDAddition.h"

const int ESBLEHIDDescriptor_Descriptors[] = {
    ESBLEHIDDescriptorUsageTag,
    ESBLEHIDDescriptorUsagePageTag,
    ESBLEHIDDescriptorUsageMinimumTag,
    ESBLEHIDDescriptorUsageMaximumTag,
    ESBLEHIDDescriptorDesignatorIndexTag,
    ESBLEHIDDescriptorDesignatorMinimumTag,
    ESBLEHIDDescriptorDesignatorMaximumTag,
    ESBLEHIDDescriptorStringIndexTag,
    ESBLEHIDDescriptorStringMinimumTag,
    ESBLEHIDDescriptorStringMaximumTag,
    ESBLEHIDDescriptorCollectionTag,
    ESBLEHIDDescriptorInputTag,
    ESBLEHIDDescriptorOutputTag,
    ESBLEHIDDescriptorFeatureTag,
    ESBLEHIDDescriptorLogicalMimimumTag,
    ESBLEHIDDescriptorLogicalMaximumTag,
    ESBLEHIDDescriptorPhysicalMimimumTag,
    ESBLEHIDDescriptorPhysicalMaximumTag,
    ESBLEHIDDescriptorUnitExponentTag,
    ESBLEHIDDescriptorUnitTag,
    ESBLEHIDDescriptorReportSizeTag,
    ESBLEHIDDescriptorReportIDTag,
    ESBLEHIDDescriptorReportCountTag,
    ESBLEHIDDescriptorDelimiterTag,
    0
};

const int ESBLEHIDDescriptor_SingleDescriptors[] = {
    ESBLEHIDDescriptorEndCollectionTag,
    ESBLEHIDDescriptorPushTag,
    ESBLEHIDDescriptorPopTag,
    0
};

NSString *const ESBLEHIDDescriptorUsageKey = @"UsageKey";
NSString *const ESBLEHIDDescriptorUsagePageKey = @"UsagePageKey";
NSString *const ESBLEHIDDescriptorUsageMinimumKey = @"UsageMinimumKey";
NSString *const ESBLEHIDDescriptorUsageMaximumKey = @"UsageMaximumKey";
NSString *const ESBLEHIDDescriptorDesignatorIndexKey = @"DesignatorIndexKey";
NSString *const ESBLEHIDDescriptorDesignatorMinimumKey = @"DesignatorMinimumKey";
NSString *const ESBLEHIDDescriptorDesignatorMaximumKey = @"DesignatorMaximumKey";
NSString *const ESBLEHIDDescriptorStringIndexKey = @"StringIndexKey";
NSString *const ESBLEHIDDescriptorStringMinimumKey = @"StringMinimumKey";
NSString *const ESBLEHIDDescriptorStringMaximumKey = @"StringMaximumKey";
NSString *const ESBLEHIDDescriptorCollectionKey = @"CollectionKey";
NSString *const ESBLEHIDDescriptorEndCollectionKey = @"EndCollectionKey";
NSString *const ESBLEHIDDescriptorInputKey = @"InputKey";
NSString *const ESBLEHIDDescriptorOutputKey = @"OutputKey";
NSString *const ESBLEHIDDescriptorFeatureKey = @"FeatureKey";
NSString *const ESBLEHIDDescriptorLogicalMimimumKey = @"LogicalMimimumKey";
NSString *const ESBLEHIDDescriptorLogicalMaximumKey = @"LogicalMaximumKey";
NSString *const ESBLEHIDDescriptorPhysicalMimimumKey = @"PhysicalMimimumKey";
NSString *const ESBLEHIDDescriptorPhysicalMaximumKey = @"PhysicalMaximumKey";
NSString *const ESBLEHIDDescriptorUnitExponentKey = @"UnitExponentKey";
NSString *const ESBLEHIDDescriptorUnitKey = @"UnitKey";
NSString *const ESBLEHIDDescriptorReportSizeKey = @"ReportSizeKey";
NSString *const ESBLEHIDDescriptorReportIDKey = @"ReportIDKey";
NSString *const ESBLEHIDDescriptorReportCountKey = @"ReportCountKey";
NSString *const ESBLEHIDDescriptorPushKey = @"PushKey";
NSString *const ESBLEHIDDescriptorPopKey = @"PopKey";
NSString *const ESBLEHIDDescriptorDelimiterKey = @"DelimiterKey";

@implementation ESBLEHIDDescriptor

//--------------------------------------------------------------------------------------------------
#pragma mark - Convinience Methods
//--------------------------------------------------------------------------------------------------

+ (id) HIDDescriptorWithData:(NSData *)data offset:(NSUInteger)offset
{
    Byte bTag;
    memccpy(&bTag, [data bytes] + offset, 1, sizeof(Byte));
    
    int tag = (int) bTag;
    NSUInteger length = 0;
    BOOL found = NO;
    
    // 1-4バイトデータ
    for (int i = 0; ESBLEHIDDescriptor_Descriptors[i] != 0; i++) {
        int tempTag = ESBLEHIDDescriptor_Descriptors[i];
        if ((tag >= tempTag) && (tag <= (tempTag + 2))) {
            found = YES;
            length = pow(2, tag - tempTag);
            tag = tempTag;
            break;
        }
    }
    
    // 0バイトデータ
    if (found == NO) {
        for (int i = 0; ESBLEHIDDescriptor_SingleDescriptors[i] != 0; i++) {
            int tempTag = ESBLEHIDDescriptor_SingleDescriptors[i];
            if (tag == tempTag) {
                found = YES;
                length = 0;
                tag = tempTag;
                break;
            }
        }
    }
    
    // 戻り値作成
    if (found) {
        NSData *parsedData = nil;
        if (length > 0) {
            parsedData = [data subdataWithRange:NSMakeRange(offset + 1, length)];
            if (length > 1) {
                // エンディアン変換(Little -> Big)
                parsedData = [parsedData ESBLEHID_dataWithEndianConvert];
            }
        }
        
        return [[self alloc] initWithTag:tag data:parsedData];
    }
    else {
        return nil;
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Initialize / Deallocating
//--------------------------------------------------------------------------------------------------

- (id) initWithTag:(ESBLEHIDDescriptorTag)tag data:(NSData *)data
{
    self = [super init];
    if (self) {
        _tag = tag;
        _data = data;
        _length = 1 + [data length];
    }
    return self;
}

-(id)initWithTag:(ESBLEHIDDescriptorTag)tag data:(NSData *)data length:(NSUInteger)length
{
    self = [super init];
    if (self) {
        _tag = tag;
        _data = nil;
        _length = length;
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Read Value
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------------
#pragma mark - Type detection
//--------------------------------------------------------------------------------------------------

- (ESBLEHIDDescriptorType)type
{
    switch (self.tag) {
        
        // Main Item (5)
        case ESBLEHIDDescriptorInputTag:
        case ESBLEHIDDescriptorOutputTag:
        case ESBLEHIDDescriptorFeatureTag:
        case ESBLEHIDDescriptorCollectionTag:
        case ESBLEHIDDescriptorEndCollectionTag:
            return ESBLEHIDDescriptorTypeMain;
            
        // Global Item (12)
        case ESBLEHIDDescriptorUsagePageTag:
        case ESBLEHIDDescriptorLogicalMimimumTag:
        case ESBLEHIDDescriptorLogicalMaximumTag:
        case ESBLEHIDDescriptorPhysicalMimimumTag:
        case ESBLEHIDDescriptorPhysicalMaximumTag:
        case ESBLEHIDDescriptorUnitExponentTag:
        case ESBLEHIDDescriptorUnitTag:
        case ESBLEHIDDescriptorReportSizeTag:
        case ESBLEHIDDescriptorReportIDTag:
        case ESBLEHIDDescriptorReportCountTag:
        case ESBLEHIDDescriptorPushTag:
        case ESBLEHIDDescriptorPopTag:
            return ESBLEHIDDescriptorTypeGlobal;
            
        // Local Item (10)
        case ESBLEHIDDescriptorUsageTag:
        case ESBLEHIDDescriptorUsageMinimumTag:
        case ESBLEHIDDescriptorUsageMaximumTag:
        case ESBLEHIDDescriptorDesignatorIndexTag:
        case ESBLEHIDDescriptorDesignatorMinimumTag:
        case ESBLEHIDDescriptorDesignatorMaximumTag:
        case ESBLEHIDDescriptorStringIndexTag:
        case ESBLEHIDDescriptorStringMinimumTag:
        case ESBLEHIDDescriptorStringMaximumTag:
        case ESBLEHIDDescriptorDelimiterTag:
            return ESBLEHIDDescriptorTypeLocal;
            
        default:
            return ESBLEHIDDescriptorTypeUnknown;
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Utility Methods
//--------------------------------------------------------------------------------------------------

+ (NSString *)descriptorDictionaryKeyFromTag:(ESBLEHIDDescriptorTag)tag
{
    switch (tag) {
        case ESBLEHIDDescriptorUsageTag: return ESBLEHIDDescriptorUsageKey;
        case ESBLEHIDDescriptorUsagePageTag: return ESBLEHIDDescriptorUsagePageKey;
        case ESBLEHIDDescriptorUsageMinimumTag: return ESBLEHIDDescriptorUsageMinimumKey;
        case ESBLEHIDDescriptorUsageMaximumTag: return ESBLEHIDDescriptorUsageMaximumKey;
        case ESBLEHIDDescriptorDesignatorIndexTag: return ESBLEHIDDescriptorDesignatorIndexKey;
        case ESBLEHIDDescriptorDesignatorMinimumTag: return ESBLEHIDDescriptorDesignatorMinimumKey;
        case ESBLEHIDDescriptorDesignatorMaximumTag: return ESBLEHIDDescriptorDesignatorMaximumKey;
        case ESBLEHIDDescriptorStringIndexTag: return ESBLEHIDDescriptorStringIndexKey;
        case ESBLEHIDDescriptorStringMinimumTag: return ESBLEHIDDescriptorStringMinimumKey;
        case ESBLEHIDDescriptorStringMaximumTag: return ESBLEHIDDescriptorStringMaximumKey;
        case ESBLEHIDDescriptorCollectionTag: return ESBLEHIDDescriptorCollectionKey;
        case ESBLEHIDDescriptorEndCollectionTag: return ESBLEHIDDescriptorEndCollectionKey;
        case ESBLEHIDDescriptorInputTag: return ESBLEHIDDescriptorInputKey;
        case ESBLEHIDDescriptorOutputTag: return ESBLEHIDDescriptorOutputKey;
        case ESBLEHIDDescriptorFeatureTag: return ESBLEHIDDescriptorFeatureKey;
        case ESBLEHIDDescriptorLogicalMimimumTag: return ESBLEHIDDescriptorLogicalMimimumKey;
        case ESBLEHIDDescriptorLogicalMaximumTag: return ESBLEHIDDescriptorLogicalMaximumKey;
        case ESBLEHIDDescriptorPhysicalMimimumTag: return ESBLEHIDDescriptorPhysicalMimimumKey;
        case ESBLEHIDDescriptorPhysicalMaximumTag: return ESBLEHIDDescriptorPhysicalMaximumKey;
        case ESBLEHIDDescriptorUnitExponentTag: return ESBLEHIDDescriptorUnitExponentKey;
        case ESBLEHIDDescriptorUnitTag: return ESBLEHIDDescriptorUnitKey;
        case ESBLEHIDDescriptorReportSizeTag: return ESBLEHIDDescriptorReportSizeKey;
        case ESBLEHIDDescriptorReportIDTag: return ESBLEHIDDescriptorReportIDKey;
        case ESBLEHIDDescriptorReportCountTag: return ESBLEHIDDescriptorReportCountKey;
        case ESBLEHIDDescriptorPushTag: return ESBLEHIDDescriptorPushKey;
        case ESBLEHIDDescriptorPopTag: return ESBLEHIDDescriptorPopKey;
        case ESBLEHIDDescriptorDelimiterTag: return ESBLEHIDDescriptorDelimiterKey;
        default:
            return nil;
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Debug
//--------------------------------------------------------------------------------------------------

-(NSString *)description
{
    return [NSString stringWithFormat:@"Descriptor Tag : %02X, Payload data: %@", self.tag, self.data];
}

@end
