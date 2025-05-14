import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'homepage_screen.dart';

void main() {
  runApp(LanguageTranslatorApp());
}

class LanguageTranslatorApp extends StatelessWidget {
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
      home: LanguageTranslatorScreen(),
    );
  }
}


class LanguageTranslatorScreen extends StatefulWidget {
  @override
  _LanguageTranslatorScreenState createState() => _LanguageTranslatorScreenState();
}

class _LanguageTranslatorScreenState extends State<LanguageTranslatorScreen> {
  TextEditingController textController = TextEditingController();
  String translationResult = "";
  bool isLoading = false;
  String selectedLanguage = "Telugu"; // Default language

  // List of available languages for translation
  final List<String> languages = [
    "Telugu",
    "Hindi",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Japanese",
    "Arabic",
    "Russian",
    "Portuguese",
    "Italian"
  ];

  // API Keys
  final List<String> apiKeys = [
    "a'
  ];

  Future<String> _getGroqTranslation(String text) async {
    setState(() {
      isLoading = true;
      translationResult = "Translating...";
    });

    for (String apiKey in apiKeys) {
      try {
        final response = await _makeGroqApiCall(apiKey, text, selectedLanguage);
        setState(() {
          isLoading = false;
          translationResult = response;
        });
        return response;
      } catch (e) {
        print("API key failed: $apiKey - Error: $e");
      }
    }

    setState(() {
      isLoading = false;
      translationResult = "API Error: All keys failed";
    });
    return "Error";
  }

  Future<String> _makeGroqApiCall(String apiKey, String text, String targetLanguage) async {
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
          'You are a translation engine. Translate ONLY the following English sentence into $targetLanguage. Do not add any explanations, greetings, or extra text. Only output the translated sentence.'
        },
        {'role': 'user', 'content': 'Translate this: $text'}
      ],
      'temperature': 0.5,
      'max_tokens': 1024,
      'top_p': 1,
    });

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 15), onTimeout: () {
      throw TimeoutException("API request timed out");
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get translation: ${response.statusCode}');
    }
  }

  void translateText() {
    String inputText = textController.text.trim();
    if (inputText.isEmpty) {
      setState(() {
        translationResult = "Please enter some text.";
      });
      return;
    }

    _getGroqTranslation(inputText);
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
                  "Language Translation",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                // Language Selection Dropdown
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      dropdownColor: Colors.grey[850],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                        });
                      },
                      items: languages
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Translate to $value"),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: textController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Enter Text To Translate...",
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
                    onPressed: isLoading ? null : translateText,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      isLoading ? "Translating..." : "Translate",
                      style: TextStyle(fontSize: 18),
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
                        translationResult.isNotEmpty
                            ? translationResult
                            : "Awaiting text to translate...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
