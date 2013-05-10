//
//  ESBLEHIDDataTree.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDataTree.h"

@interface ESBLEHIDDataTree ()

@property (strong, nonatomic) NSMutableData *readBuffer;
@property (strong, nonatomic) NSMutableArray *dataFields;

@end

@implementation ESBLEHIDDataTree

- (id)initWithDescriptorArray:(NSArray *)descriptors
{
    self = [super init];
    if (self) {
        self.readBuffer = [NSMutableData data];
        self.dataFields = [NSMutableArray array];
        [self buildDataObjectsFromDescriptors:descriptors];
    }
    return self;
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Descriptor Tree Parse
//--------------------------------------------------------------------------------------------------

- (void) buildDataObjectsFromDescriptors:(NSArray *)descriptors
{
    NSMutableDictionary *globalItems = [NSMutableDictionary dictionary];
    NSMutableDictionary *localItems = [NSMutableDictionary dictionary];
    NSMutableArray *globalItemsStack = [NSMutableArray array];
    
    ESBLEHIDDataCollection *collection = [ESBLEHIDDataCollection
                                          dataFieldWithMainItemDescriptor:nil
                                          items:nil];
    NSMutableArray *collectionStack = [NSMutableArray arrayWithObject:collection];
    
    for (ESBLEHIDDescriptor *descriptor in descriptors) {
        switch (descriptor.type) {
            case ESBLEHIDDescriptorTypeGlobal: {
                // グローバルアイテム (配列に追加するだけ)
                switch (descriptor.tag) {
                    case ESBLEHIDDescriptorPushTag: {
                        [globalItemsStack addObject:[globalItems mutableCopy]];
                    } break;
                    case ESBLEHIDDescriptorPopTag: {
                        if ([globalItemsStack count] > 0) {
                            globalItems = [globalItemsStack lastObject];
                            [globalItemsStack removeLastObject];
                        }
                        else {
                            // エラー
                            return;
                        }
                    } break;
                    default: {
                        if ([self addDescriptorValue:descriptor toDictionary:globalItems] == NO) {
                            // エラー
                            return;
                        }
                    } break;
                }
            } break;
            case ESBLEHIDDescriptorTypeLocal: {
                // ローカルアイテム
                [self addDescriptorValue:descriptor toDictionary:localItems];
            } break;
            case ESBLEHIDDescriptorTypeMain: {
                // ローカルアイテム
                switch (descriptor.tag) {
                    case ESBLEHIDDescriptorInputTag:
                    case ESBLEHIDDescriptorOutputTag:
                    case ESBLEHIDDescriptorFeatureTag: {
                        // データフィールド定義
                        ESBLEHIDDataField *dataField = [ESBLEHIDDataField
                                                        dataFieldWithMainItemDescriptor:descriptor
                                                        globalItems:globalItems
                                                        localItems:localItems];
                        dataField.data = self.readBuffer;
                        if ([self.dataFields count] > 0) {
                            ESBLEHIDDataField *lastField = [self.dataFields lastObject];
                            dataField.offset = lastField.offset + lastField.length;
                        }
                        else {
                            dataField.offset = 0;
                        }
                        [self.dataFields addObject:dataField];
                        [collection addDataField:dataField];
                    } break;
                    case ESBLEHIDDescriptorCollectionTag: {
                        // コレクション開始
                        ESBLEHIDDataCollection *newCollection = [ESBLEHIDDataCollection
                                                                 dataFieldWithMainItemDescriptor:descriptor
                                                                 globalItems:globalItems
                                                                 localItems:localItems];
                        [collection addCollection:newCollection];
                        [collectionStack addObject:newCollection];
                        collection = newCollection;
                    } break;
                    case ESBLEHIDDescriptorEndCollectionTag: {
                        // コレクション終了
                        collection = [collectionStack lastObject];
                        [collectionStack removeLastObject];
                    } break;
                    default: {
                        // エラー
                        return;
                    } break;
                }
                // ローカルアイテムクリア
                [localItems removeAllObjects];
            } break;
            default: {
                // エラー
                return;
            } break;
        }
    }
    _rootCollection = collectionStack[0];
}

- (BOOL)addDescriptorValue:(ESBLEHIDDescriptor *)descriptor toDictionary:(NSMutableDictionary *)dictionary
{
    NSString *key = [ESBLEHIDDescriptor descriptorDictionaryKeyFromTag:descriptor.tag];
    if (key != nil) {
        // Usageは複数来る可能性があるので array にする
        if (descriptor.tag == ESBLEHIDDescriptorUsageTag) {
            NSMutableArray *array = [dictionary objectForKey:key];
            if (array == nil) {
                array = [NSMutableArray array];
                dictionary[key] = array;
            }
            [array addObject:descriptor.data];
        }
        else {
            dictionary[key] = descriptor.data;
        }
        return YES;
    }
    else {
        return NO;
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Write received data
//--------------------------------------------------------------------------------------------------

- (void)writeReportData:(NSData *)data
{
    if ([data length] != [self.readBuffer length]) {
        [self.readBuffer setLength:[data length]];
    }
    memmove((void *)[self.readBuffer bytes], [data bytes], [data length]);
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Find device
//--------------------------------------------------------------------------------------------------

- (ESBLEHIDDataCollection *)findDeviceWithUsageID:(NSUInteger)usageID
{
    for (ESBLEHIDDataCollection *c in self.rootCollection.childrenCollection) {
        if (c.usage == usageID) {
            return c;
        }
    }
    return nil;
}

@end
