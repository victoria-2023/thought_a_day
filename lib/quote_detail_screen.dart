import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'quote_model.dart';

class QuoteDetailScreen extends StatelessWidget {
  final Quote quote;

  const QuoteDetailScreen({Key? key, required this.quote}) : super(key: key);

  // Function to handle sharing of quotes
  void _shareQuote() {
    final String textToShare = '"${quote.text}" - ${quote.author}';
    Share.share(textToShare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quote Detail"),
        backgroundColor: Colors.amber, // Matching the app's theme
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareQuote, // Calls the share function
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${quote.text}"',  // Adding quotation marks to stylize the quote
              style: const TextStyle(
                fontSize: 26, // Slightly larger font size for emphasis
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,  // Centering to the right
              child: Text(
                '- ${quote.author}',  // Prefixing author with dash for style
                style: const TextStyle(
                  fontSize: 20, // Slightly larger font size for better readability
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
