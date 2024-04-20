import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'quote_model.dart';

class QuoteApiService {
  final String apiUrl = "https://zenquotes.io/api/quotes"; // API URL

  // Fetches a list of quotes
  Future<List<Quote>> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          // Convert each item in the list to a Quote object
          return jsonData.map<Quote>((json) => Quote(
            text: json['q'], // 'q' for quote text
            author: json['a'], // 'a' for author
          )).toList();
        } else {
          throw Exception('No quotes found in the response.');
        }
      } else {
        // Handle the case when the server did not return a 200 OK response
        throw Exception('Failed to load quotes. Server responded with ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the HTTP request or JSON parsing
      throw Exception('Failed to load quotes: $e');
    }
  }
}
