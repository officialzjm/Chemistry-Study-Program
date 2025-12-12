import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuizApp(title: 'Flutter Demo Home Page'),
    );
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key, required this.title});

  final String title;

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {

  @override
  Widget build(BuildContext context) {
    int questionsUnknown = 0;
    int questionsRemaining = 0;
    int questionsFinished = 0;
    int currentQuestionIndex = 1;
    const List<String> questions =  [];
    const List<String> answers =  [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Program'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question Display Area
            Expanded(
              child: Center(
                child: Text(
                  questions[currentQuestionIndex],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Answer Buttons Area
            ...(answers[currentQuestionIndex]).map((answer) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => 1,//=> answerQuestion(answer),
                  child: Text(answer),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Stats and Navigation Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Unknown: $questionsUnknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Remaining: $questionsRemaining', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Finished: $questionsFinished', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
