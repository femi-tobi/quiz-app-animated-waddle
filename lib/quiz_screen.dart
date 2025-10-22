import 'dart:async';
import 'package:flutter/material.dart';

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

  // List of 10 tech-related questions
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'In what year did the United States host the FIFA World Cup for the first time?',
      'options': ['1986', '1994', '2002', '2010'],
      'answer': '1994',
    },
    {
      'question': 'Which programming language is known for its use in Android development?',
      'options': ['Swift', 'Kotlin', 'Ruby', 'Python'],
      'answer': 'Kotlin',
    },
    {
      'question': 'What year was the first iPhone released?',
      'options': ['2005', '2007', '2009', '2010'],
      'answer': '2007',
    },
    {
      'question': 'Which company developed the Python programming language?',
      'options': ['Microsoft', 'Google', 'Python Software Foundation', 'Apple'],
      'answer': 'Python Software Foundation',
    },
    {
      'question': 'What is the primary language for web development?',
      'options': ['Java', 'HTML', 'C++', 'PHP'],
      'answer': 'HTML',
    },
    {
      'question': 'In what year was the first computer bug discovered?',
      'options': ['1945', '1950', '1960', '1970'],
      'answer': '1945',
    },
    {
      'question': 'Which framework is commonly used for building single-page applications?',
      'options': ['Django', 'React', 'Flask', 'Laravel'],
      'answer': 'React',
    },
    {
      'question': 'What does CPU stand for?',
      'options': ['Central Processing Unit', 'Computer Power Unit', 'Central Program Utility', 'Control Processing Unit'],
      'answer': 'Central Processing Unit',
    },
    {
      'question': 'Which company created the Java programming language?',
      'options': ['Oracle', 'IBM', 'Sun Microsystems', 'Microsoft'],
      'answer': 'Sun Microsystems',
    },
    {
      'question': 'What year was Git initially released?',
      'options': ['2005', '2008', '2010', '2012'],
      'answer': '2005',
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
    if (!isAnswered) {
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
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        startTimer();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreScreen(score: score, total: questions.length, name: widget.name, questions: questions),
        ),
      );
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
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
        color: Color(0xFFF5F5F5), // Light gray background
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
                  Text(
                    '${currentQuestionIndex + 1}/${questions.length}',
                    style: TextStyle(fontSize: 16, color: Color(0xFF004643)),
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

class ScoreScreen extends StatelessWidget {
  final int score;
  final int total;
  final String name;
  final List<Map<String, dynamic>> questions;

  ScoreScreen({required this.score, required this.total, required this.name, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F5F5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Congratulations, $name!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('Your Score: $score/$total', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(questions: questions, score: score),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004643),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Review Answers', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int score;

  ReviewScreen({required this.questions, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F5F5),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            final isCorrect = index < score; // Simplified assumption (to be improved with actual user answers)
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text('${index + 1}. ${question['question']}'),
                subtitle: Text('Answer: ${question['answer']} ${isCorrect ? '(Correct)' : '(Incorrect)'}'),
              ),
            );
          },
        ),
      ),
    );
  } 
}