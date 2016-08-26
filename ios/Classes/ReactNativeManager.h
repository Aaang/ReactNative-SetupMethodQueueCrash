//
//  ReactNativeManager.h
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ReactNativeManager.h"
#import "ReactNativeManagerDelegate.h"
#import "ReactNativeModuleConfiguration.h"
#import "ReactNativeModuleStyling.h"

/** Represents the type of module (app) which should be loaded. */
typedef NS_ENUM(NSInteger, ReactNativeModule) {
  ReactNativeModuleUnknown    = 0,
  ReactNativeModuleTestApp    = 1
};

NS_ASSUME_NONNULL_BEGIN

/** This class handles all the React Native integration and provides a public API to the app */
@interface ReactNativeManager : NSObject

/** Returns an instance of ReactNativeManager initialized with the given reactNativeModule.
 
 @param reactNativeModule The ReactNativeModule enum identifying which react native module should be loaded, e.g. TestApp.
 */
- (instancetype)initWithReactNativeModule:(ReactNativeModule)reactNativeModule
                                 delegate:(nullable id<ReactNativeManagerDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/** Loads and returns a UIView for the given ReactNativeModule (e.g. TestApp), styling and configuration.
 
 @note This method should always be called from the main thread!
 
 @param styling         The ReactNativeModuleStyling object specifying how the React Native Module should be styled. Defaults are set on object initialization.
 @param configuration   The ReactNativeModuleConfiguration object specifying how the React Native Module should act. Defaults are set on object initialization.
 
 @return The loaded UIView (RCTRootView) or the fallback view if the React Native view couldn't be loaded.
 */
- (UIView *)loadViewWithStyling:(ReactNativeModuleStyling *)styling
                  configuration:(ReactNativeModuleConfiguration *)configuration;

/** Sends a reset event to the current React Native Module. */
- (void)resetModule;

/** Reloads the whole React Bundle. */
- (void)reloadBundle;

@end
NS_ASSUME_NONNULL_END
