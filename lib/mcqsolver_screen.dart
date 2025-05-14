import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'homepage_screen.dart';

class MCQSolverScreen extends StatefulWidget {
  @override
  _MCQSolverScreenState createState() => _MCQSolverScreenState();
}

class _MCQSolverScreenState extends State<MCQSolverScreen> {
  TextEditingController questionController = TextEditingController();
  String solverResult = "";
  bool isLoading = false;

  // API Keys
  final List<String> apiKeys = [
    'a'
  ];

  Future<String> _solveMCQ(String question) async {
    setState(() {
      isLoading = true;
      solverResult = "Analyzing...";
    });

    for (String apiKey in apiKeys) {
      try {
        final response = await _makeMCQApiCall(apiKey, question);
        setState(() {
          isLoading = false;
          solverResult = response;
        });
        return response;
      } catch (e) {
        print("API key failed: $apiKey - Error: $e");
      }
    }

    setState(() {
      isLoading = false;
      solverResult = "API Error: All keys failed";
    });
    return "Error";
  }

  Future<String> _makeMCQApiCall(String apiKey, String question) async {
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
          'You are an intelligent assistant that helps solve multiple-choice questions. '
              'If options (A, B, C, D, etc.) are provided, choose the best answer and reply in the format: A. Explanation. '
              'If no options are given, provide a concise and informative answer directly.'
        },
        {'role': 'user', 'content': question}
      ],
      'temperature': 0.3,
      'max_tokens': 150,
      'top_p': 1,
    });

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(Duration(seconds: 15), onTimeout: () {
      throw TimeoutException("API request timed out");
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      String rawResponse = data['choices'][0]['message']['content'].trim();

      // Try to match answer with explanation (e.g., A. Explanation)
      RegExp answerRegex = RegExp(r'^([A-E])[:\.\s](.*)$', multiLine: true);
      var match = answerRegex.firstMatch(rawResponse);

      if (match != null) {
        String letter = match.group(1) ?? "";
        String explanation = match.group(2)?.trim() ?? "";
        return "Answer: $letter\n\n$explanation";
      }

      // Return full model response if no pattern match
      return "Answer:\n\n$rawResponse";
    } else {
      throw Exception('Failed to solve MCQ: ${response.statusCode}');
    }
  }

  void submitQuestion() {
    String inputQuestion = questionController.text.trim();
    if (inputQuestion.isEmpty) {
      setState(() {
        solverResult = "Please enter a question.";
      });
      return;
    }

    _solveMCQ(inputQuestion);
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
                  "MCQ Solver",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: questionController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: "Enter Your Question...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        isLoading ? "Analyzing..." : "Submit",
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
                        solverResult.isNotEmpty
                            ? solverResult
                            : "Awaiting question to solve...",
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
