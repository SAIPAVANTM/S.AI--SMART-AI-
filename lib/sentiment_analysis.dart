import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:sai/homepage_screen.dart';

void main() {
  runApp(SentimentAnalysisApp());
}

class SentimentAnalysisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: SentimentAnalysisScreen(),
    );
  }
}


class SentimentAnalysisScreen extends StatefulWidget {
  @override
  _SentimentAnalysisScreenState createState() =>
      _SentimentAnalysisScreenState();
}

class _SentimentAnalysisScreenState extends State<SentimentAnalysisScreen> {
  TextEditingController textController = TextEditingController();
  String sentimentResult = "";
  bool isLoading = false;

  // API Keys
  final List<String> apiKeys = [
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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",
    "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"
  ];

  Future<String> _getGroqSentimentAnalysis(String text) async {
    setState(() {
      isLoading = true;
      sentimentResult = "Analyzing...";
    });

    for (String apiKey in apiKeys) {
      try {
        final response = await _makeGroqApiCall(apiKey, text);
        final simplifiedSentiment = _extractSimplifiedSentiment(response);
        setState(() {
          isLoading = false;
          sentimentResult = simplifiedSentiment;
        });
        return simplifiedSentiment;
      } catch (e) {
        print("API key failed: $apiKey - Error: $e");
      }
    }

    setState(() {
      isLoading = false;
      sentimentResult = "API Error: All keys failed";
    });
    return "Error";
  }

  Future<String> _makeGroqApiCall(String apiKey, String text) async {
    final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'llama-3.1-8b-instant',
      'messages': [
        {
          'role': 'system',
          'content':
          'You are a sentiment analysis assistant. Respond with only one word: "Positive", "Negative", or "Neutral".'
        },
        {'role': 'user', 'content': text}
      ],
      'temperature': 0.5,
      'max_tokens': 1024,
      'top_p': 1,
    });

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException("API request timed out");
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get sentiment: ${response.statusCode}');
    }
  }

  String _extractSimplifiedSentiment(String fullResponse) {
    final lowerResponse = fullResponse.toLowerCase();
    if (lowerResponse.contains('positive')) return 'Positive';
    if (lowerResponse.contains('negative')) return 'Negative';
    return 'Neutral';
  }

  void analyzeText() {
    String inputText = textController.text.trim();
    if (inputText.isEmpty) {
      setState(() {
        sentimentResult = "Please enter some text.";
      });
      return;
    }

    _getGroqSentimentAnalysis(inputText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Modified to navigate to HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Sentiment Analysis",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: textController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Enter Text To Analyze...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : analyzeText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      isLoading ? "Analyzing..." : "Analyze",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Sentiment",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      isLoading
                          ? CircularProgressIndicator()
                          : Text(
                        sentimentResult.isNotEmpty
                            ? sentimentResult
                            : "Awaiting Analysis...",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: sentimentResult == "Positive"
                              ? Colors.green
                              : sentimentResult == "Negative"
                              ? Colors.red
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

