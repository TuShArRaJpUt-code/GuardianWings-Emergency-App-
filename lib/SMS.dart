import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendSms(String number, String message) async {
  if (number.isEmpty || message.isEmpty) {
    throw ArgumentError('Number and message cannot be empty');
  }

  String uriString;
  if (Platform.isAndroid) {
    uriString = 'sms:$number?body=${Uri.encodeComponent(message)}';
  } else if (Platform.isIOS) {
    uriString = 'sms:$number&body=${Uri.encodeComponent(message)}';
  } else {
    throw UnsupportedError('Unsupported platform');
  }

  final uri = Uri.parse(uriString);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw Exception('Could not launch SMS app');
  }
}
