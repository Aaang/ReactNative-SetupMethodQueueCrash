/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "AppDelegate.h"

#import "ReactNativeManager.h"

@interface AppDelegate() <ReactNativeManagerDelegate>

  @property (nonatomic, strong) ReactNativeManager *reactNativeManager;
  
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // this should actually be done in a view controller,
  // but this is just for demonstrating the abstract setup
  // of our react native integration
  _reactNativeManager = [[ReactNativeManager alloc] initWithReactNativeModule:ReactNativeModuleTestApp delegate:self];
  UIView *rootView = [self.reactNativeManager loadViewWithStyling:[ReactNativeModuleStyling new] configuration:[ReactNativeModuleConfiguration new]];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

#pragma mark - ReactNativeManagerDelegate Methods

- (void)dismissReactNativeModule {
  // you can dismiss the view controller here or whatever,
  // this is just dummy call to be actually handled within
  // a view controller
}

@end
