import 'package:url_launcher/url_launcher.dart';


Future<void> openDialPad(String number) async {
  final Uri telUri = Uri(scheme: 'tel', path: number);

  if (!await launchUrl(telUri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $number';
  }
}
