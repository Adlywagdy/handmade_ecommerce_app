import 'package:url_launcher/url_launcher.dart';

class ContactSellerService {
  Future<void> sendEmail({
    required String email,
    required String sellerName,
    required String subject,
    required String message,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      throw Exception('Seller email is not available');
    }

    final uri = Uri(
      scheme: 'mailto',
      path: trimmedEmail,
      queryParameters: {
        if (subject.trim().isNotEmpty) 'subject': subject.trim(),
        'body': _buildEmailBody(sellerName: sellerName, message: message),
      },
    );

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch) {
      throw Exception('Could not open the email app');
    }
  }

  String _buildEmailBody({
    required String sellerName,
    required String message,
  }) {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isNotEmpty) {
      return trimmedMessage;
    }

    return 'Hello $sellerName,\n\nI would like to request a customized order.\n\nDetails:\n';
  }
}
