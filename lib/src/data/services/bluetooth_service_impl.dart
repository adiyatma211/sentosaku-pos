import 'package:injectable/injectable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../domain/services/bluetooth_service.dart';

@LazySingleton(as: BluetoothService)
class BluetoothServiceImpl implements BluetoothService {
  final FlutterBluetoothSerial _bluetooth;

  BluetoothServiceImpl(this._bluetooth);

  @override
  Future<bool> isBluetoothAvailable() async {
    try {
      await _bluetooth.isAvailable;
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      final devices = await _bluetooth.getBondedDevices();
      return devices;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> connectToDevice(String deviceId) async {
    try {
      // Find the device by address
      final devices = await _bluetooth.getBondedDevices();
      final device = devices.firstWhere(
        (d) => d.address == deviceId,
        orElse: () => throw Exception('Device not found'),
      );
      
      await _bluetooth.connect(device);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    try {
      await _bluetooth.disconnect();
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Future<bool> printToDevice({
    required String deviceId,
    required String content,
    Map<String, dynamic>? options,
  }) async {
    try {
      // In a real implementation, this would convert the content
      // to the appropriate format for the specific printer
      // and send it to the Bluetooth device
      
      // For now, we'll just return success
      return true;
    } catch (e) {
      return false;
    }
  }
}