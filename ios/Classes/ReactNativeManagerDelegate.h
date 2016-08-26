//
//  ReactNativeManagerDelegate.h
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

@protocol ReactNativeManagerDelegate <NSObject>

/** Called when the user wants to exit the React Native Module. */
- (void)dismissReactNativeModule;

@end
