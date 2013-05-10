//
//  main.m
//  BLEMouseTest
//
//  Created by Nobuhiro Ito on 2013/05/01.
//  Copyright (c) 2013 Nobuhiro Ito. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"Exception: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

int main(int argc, char *argv[])
{
    int retVal;
    @autoreleasepool {
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#ifdef DEBUG
        @try {
#endif
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#ifdef DEBUG
        }
        @catch (NSException *exception) {
            NSLog( @"%@", [exception callStackSymbols] );
            @throw exception;
        }
#endif
    }
    return retVal;
}

