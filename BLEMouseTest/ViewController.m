//
//  ViewController.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import "ViewController.h"
#import "ESBLEHIDUUID.h"

@interface ViewController ()


@property (strong, nonatomic) NSMutableArray *connectingPeripherals;
@property (strong, nonatomic) ESBLEHIDDriver *hidDriver;
@property (strong, nonatomic) ESBLEHIDMouseDevice *mouse;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    self.connectingPeripherals = [NSMutableArray array];
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral central:(CBCentralManager *)central
{
    if ([self.connectingPeripherals indexOfObject:peripheral] == NSNotFound) {
        [self.connectingPeripherals addObject:peripheral];
    }
    [central connectPeripheral:peripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, peripheral);
    [self connectToPeripheral:peripheral central:central];
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, peripherals);
    for (CBPeripheral *peripheral in peripherals) {
        [self connectToPeripheral:peripheral central:central];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, peripheral);
    self.hidDriver = [[ESBLEHIDDriver alloc] initWithPeripheral:peripheral];
    self.hidDriver.delegate = self;
    [self.connectingPeripherals removeObject:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.hidDriver = nil;
    [self.connectingPeripherals removeObject:peripheral];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, central);
    if (central.state == CBCentralManagerStatePoweredOn) {
        self.scanButton.enabled = YES;
    }
    else {
        self.scanButton.enabled = NO;
    }
}

- (IBAction)scanButtonPushed:(id)sender
{
    [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:ESBLEUUIDServiceHumanInterfaceDeviceString]]
                                         options:nil];
    [self.manager retrievePeripherals:@[[CBUUID UUIDWithString:ESBLEUUIDServiceHumanInterfaceDeviceString]]];
}

-(void)HIDDriverDataTreeCreated:(ESBLEHIDDriver *)driver
{
    self.mouse = [ESBLEHIDMouseDevice deviceWithDataTree:driver.dataTree];
    if (self.mouse != nil) {
        self.mouse.delegate = self;
        [self.hidDriver addDeviceForReport:self.mouse];
    }
    else {
        NSLog(@"mouse create failed!");
    }
}

- (void)mouse:(ESBLEHIDMouseDevice *)mouse pointerMovedWithAxis:(CGPoint)axis
{
    NSLog(@"%s: %f,%f", __PRETTY_FUNCTION__, axis.x, axis.y);
    CGRect rect = self.cursorView.frame;
    CGSize containerSize = self.cursorView.superview.frame.size;
    rect.origin.x += axis.x / 120;
    rect.origin.y += axis.y / 120;
    if (rect.origin.x < 0) { rect.origin.x = 0; }
    if (rect.origin.x > (containerSize.width - rect.size.height)) {
        rect.origin.x = (containerSize.width - rect.size.width);
    }
    if (rect.origin.y < 0) { rect.origin.y = 0; }
    if (rect.origin.y > (containerSize.height - rect.size.height)) {
        rect.origin.y = (containerSize.height - rect.size.height);
    }
    self.cursorView.frame = rect;
}

-(void)mouse:(ESBLEHIDMouseDevice *)mouse buttonPressedAtButtonID:(NSUInteger)buttonID
{
    NSLog(@"%s: %d", __PRETTY_FUNCTION__, buttonID);
    if (buttonID == 1) {
        self.cursorView.backgroundColor = [UIColor blueColor];
    }
    else if (buttonID == 2) {
        self.cursorView.backgroundColor = [UIColor redColor];
    }
}

-(void)mouse:(ESBLEHIDMouseDevice *)mouse buttonReleasedAtButtonID:(NSUInteger)buttonID
{
    NSLog(@"%s: %d", __PRETTY_FUNCTION__, buttonID);
    self.cursorView.backgroundColor = [UIColor whiteColor];
}

@end
