import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int score;

  ReviewPage({required this.questions, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF004643),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Color(0xFF2E7D32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Your Score: $score / ${questions.length}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 48), // Placeholder to balance the row
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final isCorrect = index < score; // Simplified assumption
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 8,
                    color: Colors.white,
                    child: ExpansionTile(
                      title: Text(
                        '${index + 1}. ${question['question']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF004643),
                        ),
                      ),
                      trailing: Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Color(0xFF2E7D32) : Colors.red,
                        size: 24,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Correct Answer: ${question['answer']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF004643),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Explanation: This question tests knowledge of ${question['question'].split(' ').first.toLowerCase()} in Flutter.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}