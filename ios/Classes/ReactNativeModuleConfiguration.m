//
//  ReactNativeModuleConfiguration.m
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ReactNativeModuleConfiguration.h"

@implementation ReactNativeModuleConfiguration

- (instancetype)init {
  self = [super init];
  if (self) {
    _showExitButton = YES;
  }
  return self;
}

@end
