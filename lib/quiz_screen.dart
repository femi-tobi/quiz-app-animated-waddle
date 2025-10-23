import 'dart:async';
import 'package:flutter/material.dart';
import 'score_page.dart';

class QuizScreen extends StatefulWidget {
  final String name;

  QuizScreen({required this.name});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int timerSeconds = 30;
  late Timer _timer;
  bool isAnswered = false;
  String? selectedOption;

  // List of 10 Flutter development questions
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What is the primary language used to build Flutter apps?',
      'options': ['Java', 'Dart', 'Swift', 'Kotlin'],
      'answer': 'Dart',
    },
    {
      'question': 'Which widget is used for state management in Flutter?',
      'options': ['StatefulWidget', 'StatelessWidget', 'Container', 'Text'],
      'answer': 'StatefulWidget',
    },
    {
      'question': 'What tool does Flutter use to compile code to native code?',
      'options': ['Gradle', 'Xcode', 'Dart SDK', 'Flutter Engine'],
      'answer': 'Flutter Engine',
    },
    {
      'question': 'Which method is called when a Flutter widget is first created?',
      'options': ['initState', 'build', 'dispose', 'setState'],
      'answer': 'initState',
    },
    {
      'question': 'What is the purpose of the pubspec.yaml file in Flutter?',
      'options': ['Define app routes', 'Manage dependencies', 'Style the UI', 'Handle state'],
      'answer': 'Manage dependencies',
    },
    {
      'question': 'Which Flutter widget allows scrolling content?',
      'options': ['ListView', 'Row', 'Column', 'Stack'],
      'answer': 'ListView',
    },
    {
      'question': 'What does the setState() method do in Flutter?',
      'options': ['Updates the UI', 'Fetches data', 'Navigates screens', 'Closes the app'],
      'answer': 'Updates the UI',
    },
    {
      'question': 'Which package is commonly used for state management in Flutter?',
      'options': ['http', 'provider', 'path', 'flutter_test'],
      'answer': 'provider',
    },
    {
      'question': 'What is the default Flutter app entry point?',
      'options': ['main.dart', 'index.dart', 'app.dart', 'home.dart'],
      'answer': 'main.dart',
    },
    {
      'question': 'Which command builds a Flutter app for web?',
      'options': ['flutter run', 'flutter build web', 'flutter pub get', 'flutter doctor'],
      'answer': 'flutter build web',
    },
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timerSeconds = 30;
    isAnswered = false;
    selectedOption = null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (timerSeconds > 0 && !isAnswered) {
          timerSeconds--;
        } else {
          _timer.cancel();
          if (!isAnswered && currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            startTimer();
          }
        }
      });
    });
  }

  void checkAnswer(String option) {
    if (!isAnswered && mounted) {
      setState(() {
        isAnswered = true;
        selectedOption = option;
        _timer.cancel();
        if (option == questions[currentQuestionIndex]['answer']) {
          score++;
        }
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1 && mounted) {
      setState(() {
        currentQuestionIndex++;
        startTimer();
      });
    } else if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            name: widget.name,
            score: score,
            total: questions.length,
            questions: questions,
          ),
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0 && mounted) {
      setState(() {
        currentQuestionIndex--;
        startTimer();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F5F5),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: previousQuestion,
                    child: Text('Previous', style: TextStyle(color: Color(0xFF004643), fontSize: 16)),
                  ),
                  SizedBox(
                    width: 200, // Adjust width as needed
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.grey[300],
                      color: Color(0xFF2E7D32),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: timerSeconds / 30,
                                backgroundColor: Colors.grey[300],
                                color: Color(0xFF004643),
                                strokeWidth: 4,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '$timerSeconds',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          questions[currentQuestionIndex]['question'],
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ...questions[currentQuestionIndex]['options'].map((option) => Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isAnswered && option == questions[currentQuestionIndex]['answer']
                                    ? Color(0xFFD9E6DC)
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: RadioListTile<String>(
                                title: Text(option, style: TextStyle(fontSize: 16)),
                                value: option,
                                groupValue: selectedOption,
                                onChanged: isAnswered ? null : (value) => checkAnswer(value!),
                                activeColor: Color(0xFF004643),
                                tileColor: isAnswered && option == selectedOption && option != questions[currentQuestionIndex]['answer']
                                    ? Colors.red[100]
                                    : null,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004643),
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}