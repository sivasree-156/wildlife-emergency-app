import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:vvxplore/user/userui.dart';


class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  late Future<List<Intent>> intentsData;
  List<Intent> intents = [];
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  String _translatedResponse = '';
  final translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts();

  final Map<String, String> languages = {
    'English': 'en',
    'Tamil': 'ta',
    'Hindi': 'hi',
    'Telugu': 'te',
    'Malayalam': 'ml',
    'Kannada': 'kn',
    'Bengali': 'bn',
    'Gujarati': 'gu',
    'Marathi': 'mr',
    'Punjabi': 'pa',
    'Urdu': 'ur',
    'Odia': 'or',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Chinese (Simplified)': 'zh-CN',
    'Chinese (Traditional)': 'zh-TW',
    'Japanese': 'ja',
    'Korean': 'ko',
    'Russian': 'ru',
    'Arabic': 'ar',
    'Portuguese': 'pt',
    'Italian': 'it',
    'Turkish': 'tr',
  };
  String _selectedLanguage = 'ta';

  @override
  void initState() {
    super.initState();
    intentsData = loadIntentsData();
    intentsData.then((data) {
      setState(() {
        intents = data;
      });
    });
  }

  Future<List<Intent>> loadIntentsData() async {
    final String response = await rootBundle.loadString('assets/intents.json');
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> intents = data['intents'] ?? [];
    return intents.map((json) => Intent.fromJson(json)).toList();
  }

  void _getResponse(String question) async {
    for (var intent in intents) {
      if (intent.patterns.any((pattern) => pattern.toLowerCase() == question.toLowerCase())) {
        String response = intent.responses.isNotEmpty ? intent.responses[0] : 'No response available';

        setState(() {
          _response = response;
          _translatedResponse = '';
        });
        return;
      }
    }
    setState(() {
      _response = 'Sorry, I don\'t understand that question.';
      _translatedResponse = '';
    });
  }

  void _translateResponse(String targetLanguage) async {
    final translation = await translator.translate(_response, to: targetLanguage);
    setState(() {
      _translatedResponse = translation.text;
    });
  }

  void _speakResponse(String text, String languageCode) async {
    await flutterTts.setLanguage(languageCode);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  // WillPopScope to handle back navigation and navigate to UserInterface
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UserInterface()), // Replace with your actual UserInterface widget
    );
    return Future.value(false); // Prevents the default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Adding WillPopScope to handle back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chatbot'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Ask me anything!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                // Input Field
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Enter your question',
                    labelStyle: TextStyle(color: Colors.deepPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.5), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Language Dropdown
                DropdownButton<String>(
                  value: _selectedLanguage,
                  style: TextStyle(color: Colors.deepPurple),
                  items: languages.keys.map((String key) {
                    return DropdownMenuItem<String>(
                      value: languages[key]!,
                      child: Text(key),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                  },
                  dropdownColor: Colors.deepPurple[50],
                  iconEnabledColor: Colors.deepPurple,
                ),
                SizedBox(height: 20),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _getResponse(_controller.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Response Text
                if (_response.isNotEmpty) ...[
                  Text(
                    'Response:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _response,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _translateResponse(_selectedLanguage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade200,
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Translate to ${languages.keys.firstWhere((key) => languages[key] == _selectedLanguage)}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  if (_translatedResponse.isNotEmpty) ...[
                    Text(
                      'Translated Response:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _translatedResponse,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _speakResponse(_translatedResponse, _selectedLanguage);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade300,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Read in ${languages.keys.firstWhere((key) => languages[key] == _selectedLanguage)}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Intent {
  final String tag;
  final List<String> patterns;
  final List<String> responses;
  final String contextSet;

  Intent({
    required this.tag,
    required this.patterns,
    required this.responses,
    required this.contextSet,
  });

  factory Intent.fromJson(Map<String, dynamic> json) {
    return Intent(
      tag: json['tag'] ?? '',
      patterns: List<String>.from(json['patterns'] ?? []),
      responses: List<String>.from(json['responses'] ?? []),
      contextSet: json['context_set'] ?? '',
    );
  }
}
