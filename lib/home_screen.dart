import 'package:flutter/material.dart';
import 'quote_api_service.dart';
import 'quote_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Quote App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Quote>> quotes;

  @override
  void initState() {
    super.initState();
    quotes = QuoteApiService().fetchQuotes(); // Fetch a batch of quotes
  }

  void refreshQuotes() {
    setState(() {
      quotes = QuoteApiService().fetchQuotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Quotes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshQuotes,
          )
        ],
      ),
      body: FutureBuilder<List<Quote>>(
        future: quotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return ErrorStateWidget(refreshQuotes: refreshQuotes);
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return QuoteCard(quote: snapshot.data![index]);
              },
            );
          } else {
            return const Text("No quotes available.");
          }
        },
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final VoidCallback refreshQuotes;
  const ErrorStateWidget({Key? key, required this.refreshQuotes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load quotes. Please try again later.",
              style: TextStyle(fontSize: 18, color: Colors.redAccent)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: refreshQuotes,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class QuoteCard extends StatelessWidget {
  final Quote quote;
  const QuoteCard({Key? key, required this.quote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(quote.text, style: const TextStyle(fontStyle: FontStyle.italic)),
        subtitle: Text(quote.author),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // Implement favorite logic
          },
        ),
      ),
    );
  }
}
