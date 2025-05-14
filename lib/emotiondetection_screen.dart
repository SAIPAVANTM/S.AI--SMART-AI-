import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'homepage_screen.dart';

class EmotionDetectionScreen extends StatefulWidget {
  @override
  _EmotionDetectionScreenState createState() => _EmotionDetectionScreenState();
}

class _EmotionDetectionScreenState extends State<EmotionDetectionScreen> {
  TextEditingController textController = TextEditingController();
  String detectionResult = "";
  bool isLoading = false;

  // API Keys - reusing the same keys from the translator
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

  Future<String> _detectEmotion(String text) async {
    setState(() {
      isLoading = true;
      detectionResult = "Detecting...";
    });

    for (String apiKey in apiKeys) {
      try {
        final response = await _makeEmotionApiCall(apiKey, text);
        setState(() {
          isLoading = false;
          detectionResult = response;
        });
        return response;
      } catch (e) {
        print("API key failed: $apiKey - Error: $e");
      }
    }

    setState(() {
      isLoading = false;
      detectionResult = "API Error: All keys failed";
    });
    return "Error";
  }

  Future<String> _makeEmotionApiCall(String apiKey, String text) async {
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
          'You are an emotion detection system. Analyze the following text and identify the primary emotion expressed (such as happy, sad, angry, surprised, confused, neutral, etc.). Only return the detected emotion name with no additional text, explanations or formatting. Just the single emotion word.'
        },
        {'role': 'user', 'content': text}
      ],
      'temperature': 0.3,
      'max_tokens': 20,
      'top_p': 1,
    });

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 15), onTimeout: () {
      throw TimeoutException("API request timed out");
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      String rawResponse = data['choices'][0]['message']['content'];

      // Clean the response to contain only the emotion word
      String cleanedResponse = rawResponse.trim();
      // Remove any punctuation or formatting that might be included
      cleanedResponse = cleanedResponse.replaceAll(RegExp(r'[^\w\s]'), '');
      // Capitalize first letter for consistent display
      if (cleanedResponse.isNotEmpty) {
        cleanedResponse = cleanedResponse[0].toUpperCase() + cleanedResponse.substring(1).toLowerCase();
      }

      return cleanedResponse;
    } else {
      throw Exception('Failed to detect emotion: ${response.statusCode}');
    }
  }

  void detectEmotion() {
    String inputText = textController.text.trim();
    if (inputText.isEmpty) {
      setState(() {
        detectionResult = "Please enter some text.";
      });
      return;
    }

    _detectEmotion(inputText);
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
                      // Navigate to HomePage
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
                  "Emotion Detection",
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
                    hintText: "Enter Text To Detect...",
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
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : detectEmotion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        isLoading ? "Detecting..." : "Detect",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Output",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 10),
                      isLoading
                          ? CircularProgressIndicator()
                          : Text(
                        detectionResult.isNotEmpty
                            ? detectionResult
                            : "Awaiting text to analyze...",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
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