import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sai/emotiondetection_screen.dart';
import 'package:sai/languagetranslation_screen.dart';
import 'package:sai/mcqsolver_screen.dart';
import 'package:sai/projectsdone_screen.dart';
import 'package:sai/sentiment_analysis.dart';
import 'package:sai/textsummarization_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chatbot.dart';
import 'login_screen.dart';

void main() {
  runApp(SmartAIHomeApp());
}

class SmartAIHomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<_FeatureItem> features = [
    _FeatureItem('Chatbot', Icons.smart_toy, (context) => ChatBotPage()),
    _FeatureItem('Sentiment Analysis', Icons.mood, (context) => SentimentAnalysisApp()),
    _FeatureItem('Text Summarization', Icons.text_snippet, (context) => TextSummarizerApp()),
    _FeatureItem('Language Translation', Icons.translate, (context) => LanguageTranslatorApp()),
    _FeatureItem('Emotion Detection', Icons.emoji_emotions, (context) => EmotionDetectionScreen()),
    _FeatureItem('MCQ Solver', Icons.auto_stories, (context) => MCQSolverScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hi There !',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // Grid of Features
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: features.map((feature) {
                      return _FeatureTile(feature: feature);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/logo.png'), // Replace with your image asset
                ),
                const SizedBox(height: 8),
                Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text('Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.white),
            title: Text('Projects Done', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Log Out', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

class _FeatureItem {
  final String title;
  final IconData icon;
  final Widget Function(BuildContext)? destinationBuilder;

  _FeatureItem(this.title, this.icon, this.destinationBuilder);
}

class _FeatureTile extends StatelessWidget {
  final _FeatureItem feature;

  const _FeatureTile({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (feature.destinationBuilder != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => feature.destinationBuilder!(context),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(feature.icon, size: 40, color: Colors.white70),
              const SizedBox(height: 12),
              Text(
                feature.title,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String about = '''
Driven Machine Learning Engineer with proven ability to design, develop, and deploy AI models using Python, TensorFlow, and PyTorch. Specializes in delivering innovative solutions in NLP, computer vision, and predictive analytics. Leverages AWS for cloud-based deployment and scaling. Skilled in visualizing data insights and optimizing performance using Power BI and SQL. Adept at managing full project lifecycles, from data preprocessing to model tuning and deployment, to deliver impactful business results.
''' ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/a.jpg'), // Replace with your image
            ),
            const SizedBox(height: 16),
            Text("About Me", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(about, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.linkedin, color: Colors.blueAccent),
                  onPressed: () => _launchURL(context, 'https://www.linkedin.com/in/saipavantm/'),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.github, color: Colors.white),
                  onPressed: () => _launchURL(context, 'https://github.com/SAIPAVANTM'),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.code, color: Colors.orangeAccent),
                  onPressed: () => _launchURL(context, 'https://leetcode.com/u/saipavantm/'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch URL')));
    }
  }
}
