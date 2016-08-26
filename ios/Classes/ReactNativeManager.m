//
//  ReactNativeManager.m
//  SetupMethodQueueCrash
//
//  Created by Philipp Anger on 24/08/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "ReactNativeManager.h"

#import <RCTBridge.h>
#import <RCTRootView.h>
#import <RCTBundleURLProvider.h>

#import "SomeNativeModule.h"

@interface ReactNativeManager() <RCTBridgeDelegate, SomeNativeModuleDelegate>

@property (nonatomic, weak) id<ReactNativeManagerDelegate> delegate;
@property (nonatomic, assign) ReactNativeModule reactNativeModule;
@property (nonatomic, strong) SomeNativeModule *someNativeModule;
@property (nonatomic, strong) RCTBridge *bridge;
@property (nonatomic, assign) BOOL reactNativeModuleLoaded;

@end

@implementation ReactNativeManager

#pragma mark - Init

- (instancetype)init {
  return [self initWithReactNativeModule:ReactNativeModuleUnknown delegate:nil];
}

- (instancetype)initWithReactNativeModule:(ReactNativeModule)reactNativeModule
                                 delegate:(id<ReactNativeManagerDelegate>)delegate {
  self = [super init];
  if (self) {
    _reactNativeModule = reactNativeModule;
    _delegate = delegate;
  }
  return self;
}

- (void)dealloc {
  _delegate = nil;
  _someNativeModule = nil;
  _bridge = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public Methods

- (UIView *)loadViewWithStyling:(ReactNativeModuleStyling *)styling
                  configuration:(ReactNativeModuleConfiguration *)configuration {
  if (![NSThread isMainThread] || !self.bridge) {
    return [UIView new];
  }

  UIView *view = [[RCTRootView alloc] initWithBridge:self.bridge
                                          moduleName:[self _moduleNameForReactNativeModule:self.reactNativeModule]
                                   initialProperties:[self _initialPropertiesWithStyling:styling configuration:configuration]];
  
  if (view) {
    self.reactNativeModuleLoaded = YES;
    return view;
  } else {
    return [UIView new];
  }
}

- (void)resetModule {
  if ([self _canSendEventsToReactNativeModule]) {
    [self.someNativeModule sendResetModuleEvent];
  }
}

- (void)reloadBundle {
  if (!self.bridge) {
    return;
  }
  
  [self.bridge reload];
}

#pragma mark - Private Getter/Setter

- (nullable RCTBridge *)bridge {
  if (!_bridge) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_bridgeDidInitializeModule:) name:RCTDidInitializeModuleNotification object:nil];
    _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
  }
  
  return _bridge;
}

#pragma mark - Private Methods - React Native Module

- (nonnull NSString *)_moduleNameForReactNativeModule:(ReactNativeModule)reactNativeModule {
  switch (reactNativeModule) {
    case ReactNativeModuleTestApp:
      return @"TestApp";
    case ReactNativeModuleUnknown:
    default:
      return @"";
  }
}

- (nonnull NSDictionary<NSString *, NSDictionary *> *)_initialPropertiesWithStyling:(ReactNativeModuleStyling *)styling configuration:(ReactNativeModuleConfiguration *)configuration {
  
  NSDictionary<NSString *, NSString *> *appTheme = @{};
  NSDictionary<NSString *, id> *appConfig = @{};
  
  appTheme    = @{@"mainColor": styling.mainColorHex};
  appConfig   = @{@"showExitButton": @(configuration.showExitButton)};
  
  return @{@"appTheme": appTheme, @"appConfig": appConfig};
}

- (BOOL)_canSendEventsToReactNativeModule {
  if (!self.reactNativeModuleLoaded) {
    return NO;
  }
  
  if (!self.someNativeModule) {
    return NO;
  }
  
  return YES;
}

#pragma mark - RCTBridgeDelegate Methods

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
  // dummy implementation
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
}

#pragma mark - SomeNativeModuleDelegate Methods

- (void)dismissModule {
  if ([self.delegate respondsToSelector:@selector(dismissReactNativeModule)]) {
    [self.delegate dismissReactNativeModule];
  }
}

#pragma mark - Notifications

- (void)_bridgeDidInitializeModule:(NSNotification *)notification {
  id moduleObject = notification.userInfo[@"module"];
  if ([moduleObject isKindOfClass:SomeNativeModule.class]) {
    _someNativeModule = moduleObject;
    _someNativeModule.delegate = self;
  }
}


@end
