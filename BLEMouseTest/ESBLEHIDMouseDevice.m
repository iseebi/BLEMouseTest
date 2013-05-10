//
//  ESBLEHIDMouseDevice.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDMouseDevice.h"

@interface ESBLEHIDMouseDevice ()

@property (strong, nonatomic) ESBLEHIDDataField *buttonField;
@property (strong, nonatomic) ESBLEHIDDataField *wheelField;
@property (strong, nonatomic) ESBLEHIDDataField *axisField;

@property (strong, nonatomic) NSMutableArray *buttonStateArray;
@property (assign, nonatomic) NSUInteger primaryButtonIndex;
@property (assign, nonatomic) NSUInteger secondaryButtonIndex;
@property (assign, nonatomic) NSUInteger wheelButtonIndex;

@property (assign, nonatomic) NSUInteger xIndex;
@property (assign, nonatomic) NSUInteger yIndex;


@property (strong, nonatomic) NSNumber *yesValue;
@property (strong, nonatomic) NSNumber *noValue;

@end

@implementation ESBLEHIDMouseDevice

+ (id) deviceWithDataTree:(ESBLEHIDDataTree *)tree
{
    id c = [tree findDeviceWithUsageID:ESBLEHIDUsageMouse];
    if (c != nil) {
        return [[self alloc] initWithDataCollection:c];
    }
    return nil;
}

-(id)initWithDataCollection:(ESBLEHIDDataCollection *)collection
{
    self = [super initWithDataCollection:collection];
    if (self) {
        
        self.yesValue = [NSNumber numberWithBool:YES];
        self.noValue = [NSNumber numberWithBool:NO];
        
        // Pointerを探す
        for (ESBLEHIDDataCollection *c in collection.childrenCollection) {
            if (c.usage == ESBLEHIDUsagePointer) {
                [self readDataTreeFromPointerCollection:c];
            }
        }
        
    }
    return self;
}

- (void)readDataTreeFromPointerCollection:(ESBLEHIDDataCollection *)collection
{
    for (ESBLEHIDDataField *field in collection.childrenDataField) {
        if ([field hasUsage]) {
            if (field.usagePage == ESBLEHIDUsagePageButton) {
                // ボタン
                self.buttonField = field;
                
                self.buttonStateArray = [NSMutableArray array];
                for (int i = 0; i < field.fieldCount; i++) {
                    NSUInteger usage = [field usageAtIndex:i];
                    [self.buttonStateArray addObject:self.noValue];
                    if (usage == 1) { self.primaryButtonIndex = i; }
                    if (usage == 2) { self.secondaryButtonIndex = i; }
                    if (usage == 3) { self.wheelButtonIndex = i; }
                }
            }
//            else if (field.usage == ESBLEHIDUsageWheel) {
//                // ホイール
//                self.wheelField = field;
//            }
            else if ((field.usage == ESBLEHIDUsageX) || (field.usage == ESBLEHIDUsageY)) {
                // 座標
                self.axisField = field;
                for (int i = 0; i < field.fieldCount; i++) {
                    NSUInteger usage = [field usageAtIndex:i];
                    if (usage == ESBLEHIDUsageX) {
                        self.xIndex = i;
                    }
                    else if (usage == ESBLEHIDUsageY) {
                        self.yIndex = i;
                    }
                }
            }
        }
    }
}

- (void)reportValueUpdated
{
    // 座標更新
    CGPoint point = CGPointMake([self.axisField integerValueAtIndex:self.xIndex],
                                [self.axisField integerValueAtIndex:self.yIndex]);
    if ((point.x != self.position.x) || (point.y != self.position.y))
    {
        // 座標更新された
        _position = point;
        NSLog(@"axis changed: %f,%f", point.x, point.y);
        [self.delegate mouse:self pointerMovedWithAxis:point];
    }
    
    // ボタン
    for (int i = 0; i < self.buttonField.fieldCount; i++) {
        NSUInteger usage = [self.buttonField usageAtIndex:i];
        BOOL state = [self.buttonField boolValueAtIndex:i];
        if (state != [self.buttonStateArray[i] boolValue]) {
            // 状態更新された
            if (state) {
                self.buttonStateArray[i] = self.yesValue;
            }
            else {
                self.buttonStateArray[i] = self.noValue;
            }
            NSLog(@"button %d changed: %d", usage, state);
            if (state) {
                [self.delegate mouse:self buttonPressedAtButtonID:usage];
            }
            else {
                [self.delegate mouse:self buttonReleasedAtButtonID:usage];
            }
        }
    }
}

//--------------------------------------------------------------------------------------------------
#pragma mark - Button state
//--------------------------------------------------------------------------------------------------

- (BOOL)buttonPressedForButtonID:(NSUInteger)buttonID
{
    for (int i = 0; i < self.buttonField.fieldCount; i++) {
        NSUInteger usage = [self.buttonField usageAtIndex:i];
        if (usage == buttonID) {
            return [self buttonPressedAtIndex:i];
        }
    }
    return NO;
}

-(BOOL)buttonPressedAtIndex:(NSUInteger)index
{
    return [self.buttonStateArray[index] boolValue];
}

-(BOOL)primaryButtonPressed
{
    return [self buttonPressedAtIndex:self.primaryButtonIndex];
}

-(BOOL)secondaryButtonPressed
{
    return [self buttonPressedAtIndex:self.secondaryButtonIndex];
}


-(BOOL)wheelButtonPressed
{
    return [self buttonPressedAtIndex:self.wheelButtonIndex];
}

@end
