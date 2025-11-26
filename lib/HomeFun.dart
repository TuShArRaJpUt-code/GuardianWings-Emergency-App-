// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// Future<void> sendWhatsappFallback() async {
//   final prefs = await SharedPreferences.getInstance();
//   final phonesStr = prefs.getString("contact_phones") ?? "";
//   final namesStr = prefs.getString("contact_names") ?? "";
//
//   // Split into lists
//   final phones = phonesStr.split(",").where((p) => p.trim().isNotEmpty).toList();
//   final names = namesStr.split(",").where((n) => n.trim().isNotEmpty).toList();
//
//   final message = Uri.encodeComponent(
//       "🚨 This is an emergency alert from Guardian Angel! Please contact me immediately."
//   );
//
//   if (phones.isNotEmpty) {
//     // ✅ Contacts found – send WhatsApp message to all of them
//     for (var phone in phones) {
//       // Ensure proper phone format (with country code if needed)
//       String cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
//       if (!cleanPhone.startsWith('+')) {
//         cleanPhone = '+91$cleanPhone'; // 🇮🇳 Default to India — adjust as needed
//       }
//
//       final url = Uri.parse("https://wa.me/$cleanPhone?text=$message");
//       if (await canLaunchUrl(url)) {
//         await launchUrl(url, mode: LaunchMode.externalApplication);
//       } else {
//         print("⚠️ Could not launch WhatsApp for $cleanPhone");
//       }
//     }
//   } else {
//     // ❌ No contacts found – open WhatsApp to let user pick manually
//     final fallbackUrl = Uri.parse("https://wa.me/?text=$message");
//     if (await canLaunchUrl(fallbackUrl)) {
//       await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
//     } else {
//       print("⚠️ Could not open WhatsApp fallback.");
//     }
//   }
// }
//
//


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendWhatsappFallback() async {
  final prefs = await SharedPreferences.getInstance();
  final phonesStr = prefs.getString("contact_phones") ?? "";
  final namesStr = prefs.getString("contact_names") ?? "";
  final id = prefs.getString("id") ?? "";

  final message = Uri.encodeComponent(
      "🚨I am in danger!\n📍 Live Tracking:\nhttps://livetrackingguardianangel.onrender.com/$id"
  );

  if (phonesStr.trim().isNotEmpty) {
    // ✅ Contacts found – log in console
    print("📱 Contacts found: $phonesStr");

    // Open WhatsApp with general message so user can pick contact
    final url = Uri.parse("https://wa.me/?text=$message");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("⚠️ Could not open WhatsApp.");
    }
  } else {
    // ❌ No contacts found – log in console
    print("❌ No contacts found. Opening WhatsApp fallback...");

    // Open WhatsApp fallback
    final url = Uri.parse("https://wa.me/?text=$message");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("⚠️ Could not open WhatsApp fallback.");
    }
  }
}
