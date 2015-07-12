//
//  RCTRFDuinoScan.m
//  test
//
//  Created by Christopher on 7/11/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//


#import "RFduinoManager.h"
#import "RFduino.h"

#import "RCTEventDispatcher.h"
#import "RCTRFDuinoScan.h"

static NSString* didDiscoverRFduino = @"didDiscoverRFduino";
static NSString* didUpdateRFduino = @"didUpdateRFduino";
static NSString* didConnectRFduino = @"didConnectRFduino";
static NSString* didLoadServiceRFduino = @"didLoadServiceRFduino";
static NSString* didDisconnectRFduino = @"didDisconnectRFduino";

@implementation RCTRFDuinoScan

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (instancetype)init
{
  if (self = [super init]) {
    
    rfduinoManager = [RFduinoManager sharedRFduinoManager];
    rfduinoManager.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
  }
  
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - JavaScript

- (NSDictionary *)constantsToExport
{
  return @{
           @"didDiscoverRFduino": didDiscoverRFduino,
           @"didUpdateRFduino": didUpdateRFduino,
           @"didConnectRFduino": didConnectRFduino,
           @"didLoadServiceRFduino": didLoadServiceRFduino,
           @"didDisconnectRFduino": didDisconnectRFduino,
           };
}


RCT_REMAP_METHOD(connectToRFDuinoAsync,
                 peripheral:(NSString *)peripheral
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    resolve(peripheral);
  });
}


- (NSDictionary*)getDictionaryForDevices:(NSMutableArray*)devices {
  
  // TODO: Create proper Dictionary if multiple devices are present
  
  for(RFduino *device in devices) {
    
    NSString *advertising = @"";
    if (device.advertisementData) {
      advertising = [[NSString alloc] initWithData:device.advertisementData encoding:NSUTF8StringEncoding];
    }
    
    return @{
             @"name": [NSString stringWithString:device.name],
             @"peripheral": [NSString stringWithString:[device.peripheral.identifier UUIDString]],
             @"advertising": [NSString stringWithString:advertising],
             @"advertisementRSSI": [NSNumber numberWithInt:device.advertisementRSSI.intValue],
             @"advertisementPackets": [NSNumber numberWithLong:device.advertisementPackets],
             @"outOfRange": [NSNumber numberWithLong:device.outOfRange]
      };
  }
  
  return nil;
}

#pragma mark - App lifecycle handlers

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
  NSLog(@"%@", notification);

}

- (void)applicationWillResignActive:(NSNotification *)notification
{
  NSLog(@"%@", notification);

}

#pragma mark - RfduinoDiscoveryDelegate methods

- (void)didDiscoverRFduino:(RFduino *)rfduino
{
    NSLog(@"didDiscoverRFduino");
    [self.bridge.eventDispatcher sendDeviceEventWithName:didDisconnectRFduino body:nil];
  
}

- (void)didUpdateDiscoveredRFduino:(RFduino *)rfduino
{
//    NSLog(@"didUpdateRFduino");
    [self.bridge.eventDispatcher sendDeviceEventWithName:didUpdateRFduino body:[self getDictionaryForDevices:[rfduinoManager rfduinos]]];
}

- (void)didConnectRFduino:(RFduino *)rfduino
{
    NSLog(@"didConnectRFduino");
    [self.bridge.eventDispatcher sendDeviceEventWithName:didConnectRFduino body:nil];

    [rfduinoManager stopScan];
//    loadService = false;
}

- (void)didLoadServiceRFduino:(RFduino *)rfduino
{
      NSLog(@"didLoadServiceRFduino");
      [self.bridge.eventDispatcher sendDeviceEventWithName:didLoadServiceRFduino body:nil];
  
//    loadService = true;
}

- (void)didDisconnectRFduino:(RFduino *)rfduino
{
    NSLog(@"didDisconnectRFduino");
    [self.bridge.eventDispatcher sendDeviceEventWithName:didDisconnectRFduino body:nil];
    [rfduinoManager startScan];
}

@end
