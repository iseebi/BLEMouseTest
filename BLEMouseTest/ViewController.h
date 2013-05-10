//
//  ViewController.h
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>
#import "ESBLEHIDDriver.h"
#import "ESBLEHIDMouseDevice.h"

@interface ViewController : UIViewController <CBCentralManagerDelegate, ESBLEHIDDriverDelegate, ESBLEHIDMouseDeviceDelegate>

@property (strong, nonatomic) CBCentralManager *manager;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIView *cursorView;

- (IBAction)scanButtonPushed:(id)sender;

@end
