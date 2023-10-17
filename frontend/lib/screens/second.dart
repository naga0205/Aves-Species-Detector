
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondScreen extends StatelessWidget {
  final String url;

  const SecondScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The prediction result is available at:'),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(url));
              },
              child: Text(url.substring(7)),
            ),
          ],
        ),
      ),
    );
  }
}