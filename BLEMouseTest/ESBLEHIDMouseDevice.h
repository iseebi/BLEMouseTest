//
//  ESBLEHIDMouseDevice.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ESBLEHIDDevice.h"

#import <UIKit/UIKit.h>

@class ESBLEHIDMouseDevice;

@protocol ESBLEHIDMouseDeviceDelegate <NSObject>

- (void)mouse:(ESBLEHIDMouseDevice *)mouse pointerMovedWithAxis:(CGPoint)axis;
- (void)mouse:(ESBLEHIDMouseDevice *)mouse buttonPressedAtButtonID:(NSUInteger)buttonID;
- (void)mouse:(ESBLEHIDMouseDevice *)mouse buttonReleasedAtButtonID:(NSUInteger)buttonID;

@end

@interface ESBLEHIDMouseDevice : ESBLEHIDDevice

@property (weak, nonatomic) id<ESBLEHIDMouseDeviceDelegate> delegate;

@property (assign, readonly, nonatomic) NSUInteger buttonCount;

@property (assign, readonly, nonatomic) BOOL primaryButtonPressed;
@property (assign, readonly, nonatomic) BOOL secondaryButtonPressed;
@property (assign, readonly, nonatomic) BOOL wheelButtonPressed;

@property (assign, readonly, nonatomic) CGPoint position;

- (BOOL)buttonPressedForButtonID:(NSUInteger)buttonID;

@end
