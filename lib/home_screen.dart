import 'package:flutter/material.dart';
import 'quote_api_service.dart';
import 'quote_model.dart';
import 'quote_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Quote>> quotes;

  @override
  void initState() {
    super.initState();
    quotes = QuoteApiService().fetchQuotes(); // Initially fetch quotes
  }

  void refreshQuotes() {
    setState(() {
      quotes = QuoteApiService().fetchQuotes(); // Refresh to get new quotes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quotes"),
        backgroundColor: Colors.amber, // Consistent with your app's theme
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshQuotes, // Refresh button to load new quotes
          )
        ],
      ),
      body: FutureBuilder<List<Quote>>(
        future: quotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Better UX while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}")); // Centered error message
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Quote quote = snapshot.data![index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuoteDetailScreen(quote: quote)),
                  ),
                  child: QuoteCard(quote: quote), // Modularized quote display as a separate widget
                );
              },
            );
          } else {
            return const Center(child: Text("No quotes available.")); // Centered text for no data
          }
        },
      ),
    );
  }
}

class QuoteCard extends StatefulWidget {
  final Quote quote;
  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool isFavorited = false; // Local state for favoriting

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Slight shadow for better UX
      child: ListTile(
        title: Text(widget.quote.text),
        subtitle: Text(widget.quote.author),
        trailing: IconButton(
          icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
          color: isFavorited ? Colors.red : null,
          onPressed: toggleFavorite, // Toggle favorite state
        ),
      ),
    );
  }
}
