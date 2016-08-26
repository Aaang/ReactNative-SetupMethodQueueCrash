//
//  SomeNativeModule.m
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "SomeNativeModule.h"

static NSString * const kResetModuleEvent = @"resetModule";

@interface SomeNativeModule() <RCTBridgeModule>

@property (nonatomic, assign) BOOL isEventEmitterReady;

@end

@implementation SomeNativeModule

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}

- (void)setDelegate:(id<SomeNativeModuleDelegate>)delegate {
  _delegate = delegate;
}

RCT_EXPORT_METHOD(dismissModule) {
  if ([self.delegate respondsToSelector:@selector(dismissModule)]) {
    [self.delegate dismissModule];
  }
}

#pragma mark - RCTEventEmitter Events

- (NSArray<NSString *> *)supportedEvents {
  return @[kResetModuleEvent];
}

- (void)startObserving {
  self.isEventEmitterReady = YES;
}

- (void)stopObserving {
  self.isEventEmitterReady = NO;
}

- (void)sendResetModuleEvent {
  if (!self.isEventEmitterReady) {
    return;
  }
  
  [self sendEventWithName:kResetModuleEvent body:nil];
}

#pragma mark - RCTBridgeModule Delegate Methods

- (NSDictionary *)constantsToExport {
  return @{ @"LOCALE" : @"en" };
}

@end
