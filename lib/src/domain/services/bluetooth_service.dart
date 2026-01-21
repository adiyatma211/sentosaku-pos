import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class BluetoothService {
  /// Check if Bluetooth is available
  Future<bool> isBluetoothAvailable();

  /// Get paired Bluetooth devices
  Future<List<BluetoothDevice>> getPairedDevices();

  /// Connect to a Bluetooth device
  Future<bool> connectToDevice(String deviceId);

  /// Disconnect from a Bluetooth device
  Future<void> disconnectDevice(String deviceId);

  /// Print to a Bluetooth device
  Future<bool> printToDevice({
    required String deviceId,
    required String content,
    Map<String, dynamic>? options,
  });
}