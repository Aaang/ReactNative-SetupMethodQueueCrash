//
//  SomeNativeModule.h
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <RCTEventEmitter.h>

#import "SomeNativeModuleDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/** This class represents the direct interface between the React Native Module
    and the native app. It acts as a native module and sends events to JS.
 */
@interface SomeNativeModule : RCTEventEmitter

@property (nonatomic, weak) id<SomeNativeModuleDelegate> delegate;

/** This method gets called when the user taps on "Back", "Exit" or sth similar that should trigger the dismissal of the active React Native Module.
 
 @note  The native application should listen to this notification and handle the proper dismissal of the React Native Module (View).
 */
- (void)dismissModule;

/** This method will send an event to the JS side via the RCTEventEmitter to reset the module. */
- (void)sendResetModuleEvent;

@end
NS_ASSUME_NONNULL_END
