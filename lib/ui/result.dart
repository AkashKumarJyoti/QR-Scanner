import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ResultPage extends StatelessWidget {
  final String data;

  const ResultPage({Key? key, required this.data}) : super(key: key);

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.white,
        content: Center(
          child: Text(
            'Copied to clipboard',
            style: TextStyle(
              color: Color(0xFFBA68C8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context) async {
    String url = data;
    try {
      await launcher.launch(url);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Center(
            child: Text(
              'Unable to open the URL',
              style: TextStyle(
                color: Color(0xFFBA68C8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Page',
          style: TextStyle(
            color: Color(0xFFFAFAFA),
          ),
        ),
        backgroundColor: const Color(0xFFBA68C8),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Center(child: Image.asset("images/QR.png", height: 100, width: 100)),
            const SizedBox(height: 16),
            const Text(
              'Scanned Data:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL(context),
              child: Text(
                data,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xCFBA68C8)),
              ),
              onPressed: () => _copyToClipboard(context),
              child: const Text('Copy to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}

