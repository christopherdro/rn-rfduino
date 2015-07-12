//
//  RCTRFDuinoScan.h
//  test
//
//  Created by Christopher Dro on 7/11/15.
//  Copyright (c) 2015 Blick Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "RFduinoManagerDelegate.h"
#import "RCTBridgeModule.h"

@class RFduinoManager;
@class RFduino;

@interface RCTRFDuinoScan : NSObject <RCTBridgeModule, RFduinoManagerDelegate> {
      RFduinoManager *rfduinoManager;
}

@end
