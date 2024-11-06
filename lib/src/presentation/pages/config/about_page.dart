import 'package:flutter/material.dart';
import 'package:sound_ground/src/core/constants/assets.dart';
import 'package:sound_ground/src/l10n/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.l10n.aboutPageTitle,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.aboutPageSubtitle,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // QR Code image
              Image.asset(
                Assets.qr_code,
                height: 350,
                width: 350,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.aboutPageQRHint,
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Patreon button
              ElevatedButton.icon(
                onPressed: () {
                  // Open Patreon link
                  final patreonUrl = Uri.parse(
                      "https://www.patreon.com/c/user/membership?u=37091010");
                  _launchURL(patreonUrl);
                },
                icon: const Icon(Icons.favorite),
                label: Text(context.l10n.aboutPagePatreonButton),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.pinkAccent,
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () async {
                  // Send email
                  await _sendEmail();
                },
                child: Text(
                  context.l10n.aboutPageEnding,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'quandangnhu@gmail.com',
      query: '', //add subject and body here
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not send email $params';
    }
  }
}
