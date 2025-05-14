import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Projects Done', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ProjectsList(),
    );
  }
}

class ProjectsList extends StatelessWidget {
  // Add platform configuration information
  // This should be called in your main.dart or somewhere before using URL launcher
  void initializeUrlLauncher() {
    // This is required for Android 11+ (API level 30+)
    // Make sure to add these to your AndroidManifest.xml:
    /*
    <queries>
      <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="https" />
      </intent>
    </queries>
    */
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildProjectCard(
          title: "SENTIBITES - Food Review App",
          date: "Dec 2024 - Mar 2025",
          description: "This project analyzes customer reviews from a food delivery app to classify sentiment as positive, negative, or neutral. By understanding user feedback, the business can enhance its services, improve customer satisfaction, and make data-driven decisions.",
          skills: ["Python", "Flutter", "Flask", "PHP", "XAMPP", "Android Studio", "MySQL"],
          link: "https://github.com/SAIPAVANTM/Sentibites---Review-Sentiment-Analysis-in-Food-App",
          color: Color(0xFF5C6BC0),
        ),

        _buildProjectCard(
          title: "Building and Deploying a Question Answering System",
          date: "Aug 2024 - Sep 2024",
          description: "A Question Answering (QA) system that functions like an advanced search engine, understanding questions and seeking out exact answers within text. Leveraging machine learning to mimic human-like answer-finding behavior for quick information retrieval.",
          skills: ["Python", "Machine Learning", "NLP", "LangChain", "RAG", "Vectorstore", "Deep Learning", "LLM"],
          link: "https://github.com/SAIPAVANTM/Building-and-Deploying-a-Question-Answering-System-with-Hugging-Face",
          color: Color(0xFF26A69A),
        ),

        _buildProjectCard(
          title: "EmotionSphere: Connecting Through Emotions",
          date: "Sep 2024",
          description: "An innovative social media app designed to enhance emotional connection among users. Utilizes advanced emotion recognition technology to analyze sentiments expressed in text and speech, with features like emotion recognition from captions, multilingual speech recognition, and personalized content.",
          skills: ["Flask", "Flutter", "LLM", "AI", "Machine Learning", "XAMPP", "MySQL", "PHP", "NLP", "Data Visualization"],
          link: "https://github.com/SAIPAVANTM/EmotionSphere-Connecting-Through-Emotions",
          color: Color(0xFFEF5350),
        ),

        _buildProjectCard(
          title: "Phonepe Pulse Data Visualization & Exploration",
          date: "Jun 2024",
          description: "Extracting data from the Phonepe pulse Github repository to process and visualize metrics and statistics in a user-friendly manner, providing insights and valuable information.",
          skills: ["Python", "MySQL"],
          link: "https://github.com/SAIPAVANTM/Phonepe-Pulse-Data-Visualization-and-Exploration",
          color: Color(0xFF7E57C2),
        ),

        _buildProjectCard(
          title: "Youtube Data Harvesting And Warehousing",
          date: "May 2024",
          description: "A Streamlit application for accessing data from multiple YouTube channels, analyzing their statistics, and storing them in MySQL. This comprehensive platform retrieves data and provides insightful analysis and robust storage capabilities.",
          skills: ["Python", "MySQL"],
          link: "https://github.com/SAIPAVANTM/Youtube-Data-Harvesting-And-Warehousing-using-SQL-and-Streamlit",
          color: Color(0xFFFF7043),
        ),

        _buildProjectCard(
          title: "2048 Game",
          date: "Dec 2023",
          description: "An implementation of the popular 2048 game, a single-player sliding block puzzle played on a 4x4 grid where players combine numbered tiles by sliding them in four directions. The objective is to create a tile with the number 2048.",
          skills: ["Python", "File Management"],
          link: "https://github.com/SAIPAVANTM/2048-Game-Project",
          color: Color(0xFFFFB74D),
        ),

        _buildProjectCard(
          title: "Huffman Coding",
          date: "Dec 2023",
          description: "Implementation of Huffman Coding for text compression, a lossless data compression algorithm that creates variable-length codes for frequently occurring characters, optimizing storage and transmission.",
          skills: ["Python", "Optimization", "Algorithm Design", "Debugging", "File Management"],
          link: "https://github.com/SAIPAVANTM/Huffman-Coding",
          color: Color(0xFF66BB6A),
        ),

        _buildProjectCard(
          title: "FAST TRAVELS",
          date: "Apr - Jun 2022",
          description: "A trusted Python-based travel application with the motto 'FOR THE BEST AND ACCURATE TRAVEL, USE FAST TRAVELS.' Designed to address the issue of fake and untrusted travel apps in the market.",
          skills: ["Python", "Alexa", "MySQL"],
          link: "https://github.com/SAIPAVANTM/Fast-Travels",
          color: Color(0xFF42A5F5),
        ),
      ],
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String date,
    required String description,
    required List<String> skills,
    required String link,
    required Color color,
  }) {
    // Function to launch URLs
    Future<void> _launchProjectURL() async {
      try {
        final Uri url = Uri.parse(link);
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: 20),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.launch, color: Colors.white),
                  onPressed: _launchProjectURL,
                ),
              ],
            ),
          ),

          // Project Description
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),

          // Skills Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skills',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((skill) => _buildSkillChip(skill)).toList(),
                ),
              ],
            ),
          ),

          // GitHub Link
          Padding(
            padding: EdgeInsets.all(16),
            child: InkWell(
              onTap: _launchProjectURL,
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.github, color: Colors.white70, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      link,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    IconData? getIconForSkill(String skillName) {
      final lowerSkill = skillName.toLowerCase();
      if (lowerSkill.contains('python')) return FontAwesomeIcons.python;
      if (lowerSkill.contains('flutter')) return FontAwesomeIcons.mobile;
      if (lowerSkill.contains('flask')) return FontAwesomeIcons.server;
      if (lowerSkill.contains('php')) return FontAwesomeIcons.php;
      if (lowerSkill.contains('mysql')) return FontAwesomeIcons.database;
      if (lowerSkill.contains('android')) return FontAwesomeIcons.android;
      if (lowerSkill.contains('machine learning')) return FontAwesomeIcons.brain;
      if (lowerSkill.contains('nlp')) return FontAwesomeIcons.comment;
      if (lowerSkill.contains('ai')) return FontAwesomeIcons.robot;
      if (lowerSkill.contains('deep learning')) return FontAwesomeIcons.layerGroup;
      if (lowerSkill.contains('algorithm')) return FontAwesomeIcons.code;
      if (lowerSkill.contains('xampp')) return FontAwesomeIcons.server;
      if (lowerSkill.contains('data visualization')) return FontAwesomeIcons.chartLine;
      if (lowerSkill.contains('file')) return FontAwesomeIcons.file;
      if (lowerSkill.contains('alexa')) return FontAwesomeIcons.assistiveListeningSystems;
      return FontAwesomeIcons.laptopCode;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            getIconForSkill(skill),
            size: 12,
            color: Colors.white70,
          ),
          SizedBox(width: 6),
          Text(
            skill,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// To use this page, add it to your routes or navigate to it like:
// Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectsPage()));