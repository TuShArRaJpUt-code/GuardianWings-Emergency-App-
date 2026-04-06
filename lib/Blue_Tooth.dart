import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
final BluetoothService bluetoothService = BluetoothService();
class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  BluetoothConnection? connection;

  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get messages => _controller.stream;

  Future<void> initBluetooth() async {
    await FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return await FlutterBluetoothSerial.instance.getBondedDevices();
  }

  Future<bool> connect(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);

      connection!.input!.listen((data) {
        String message = String.fromCharCodes(data).trim();
        _controller.add(message);
      });

      return true;
    } catch (e) {
      print("Connection error: $e");
      return false;
    }
  }
}