/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  NativeEventEmitter,
  NativeModules,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import SomeNativeModule from './src/SomeNativeModule';

const RESET_MODULE_EVENT = 'resetModule';

let resetModuleListener;

class TestApp extends Component {

  constructor(props) {
    super(props);

    this._resetModule = this._resetModule.bind(this);
    this._dismissModule = this._dismissModule.bind(this);
  }

  componentDidMount() {
    const someNativeModuleEvents = new NativeEventEmitter(NativeModules.SomeNativeModule);
    resetModuleListener = someNativeModuleEvents.addListener(RESET_MODULE_EVENT, this._resetModule);
  }

  componentWillUnmount() {
    resetModuleListener.remove();
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.android.js
        </Text>
        <Text style={styles.instructions}>
          Double tap R on your keyboard to reload,{'\n'}
          Shake or press menu button for dev menu
        </Text>
      </View>
    );
  }

  _resetModule() {
    // nothing implented here, it's just abstract dummy code
  }

  _dismissModule() {
    // actually never gets called, it's just abstract dummy code
    SomeNativeModule.dismissModule();
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

AppRegistry.registerComponent('TestApp', () => TestApp);
