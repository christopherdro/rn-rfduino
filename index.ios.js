/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');

var {
  AppRegistry,
  StyleSheet,
  DeviceEventEmitter,
  NativeModules: {
    RCTRFDuinoScan,
  },  
  Text,
  TouchableHighlight,
  View,
} = React;

var test = React.createClass({

  getInitialState() {
    return {
      devices: null
    };
  },

  componentWillMount() {
    let didUpdateRFduino = DeviceEventEmitter.addListener('didUpdateRFduino', (event) => {
      this.setState({devices: event});
    });
    
    let didDiscoverRFduino = DeviceEventEmitter.addListener('didDiscoverRFduino', (event) => {
      this.setState({devices: event});
    });
  },

  componentWillUnMount () {
    didUpdateRFduino.remove();
    didDiscoverRFduino.remove();
  },

  connectToDevice(peripheral) {
    RCTRFDuinoScan.connectToRFDuinoAsync(peripheral).then((result) => {
      console.log(`Connecting to: ${result}`);
    });  
  },

  renderDevices() {
    let devices = this.state.devices;

    if (devices) {
      return (
        <TouchableHighlight 
        onPress={() => this.connectToDevice(devices.peripheral)}>
          <View>
            <Text>name: {devices.name}</Text>
            <Text>peripheral: {devices.peripheral}</Text>
            <Text>advertising: {devices.advertising}</Text>
            <Text>advertisementRSSI: {devices.advertisementRSSI}</Text>
            <Text>advertisementPackets: {devices.advertisementPackets}</Text>
            <Text>outOfRange: {devices.outOfRange}</Text>
          </View>
        </TouchableHighlight>
      );
    }
  },

  render: function() {
    console.log(RCTRFDuinoScan);
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          Connected RF Duinos
        </Text>
          {this.renderDevices()}
      </View>
    );
  }
});

var styles = StyleSheet.create({
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

AppRegistry.registerComponent('test', () => test);
