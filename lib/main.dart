import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chemistry Study Program',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        primaryColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const QuizApp(title: 'Quiz Program'),
    );
  }
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key, required this.title});

  final String title;

  @override
  State<QuizApp> createState() => _QuizAppState();
}
class Question {
  final String type; // "tf" or "mc"
  final String text;
  final List<String> answers;
  final int correctIndex;

  Question({
    required this.type,
    required this.text,
    required this.answers,
    required this.correctIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json["type"],
      text: json["text"],
      answers: List<String>.from(json["answers"]),
      correctIndex: json["correctIndex"],
    );
  }
}


class _QuizAppState extends State<QuizApp> {
  
  List<Question> questions = [];
  List<int> questionsUnknown = [];
  List<int> questionsToReview = [];
  List<int> questionsFinished = [];
  int currentQuestionIndex = 0;

  Map<int, Color> answerButtonColors = {};
  bool answered = false;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    
    final String data = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonResult = jsonDecode(data);
    setState(() {
      questions = jsonResult.map((q) => Question.fromJson(q)).toList();
      questionsUnknown = List.generate(questions.length, (i) => i);
      questionsToReview = [];
      questionsFinished = [];
    });
  }

  void nextQuestion() {
    answered = false;
    selectedAnswerIndex = null;

    if (questionsUnknown.isNotEmpty) {
      currentQuestionIndex = questionsUnknown[Random().nextInt(questionsUnknown.length)];
    } else if (questionsToReview.isNotEmpty) {
      currentQuestionIndex = questionsToReview[Random().nextInt(questionsToReview.length)];
    } else {
      currentQuestionIndex = -1;
    }

    setState(() {});
  }


  void answerQuestion(int passedAnswerIndex) { //function kept and not integrated incase of future use
    answered = true;
    selectedAnswerIndex = passedAnswerIndex;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //quiz complete check
    if (currentQuestionIndex == -1 || questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chemistry Quiz Program')),
        body: const Center(
          child: Text(
            'Quiz Complete!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    //end check

    return Scaffold( 
      appBar: AppBar(
        title: const Text('Chemistry Quiz Program'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    questions[currentQuestionIndex].text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                ...(questions[currentQuestionIndex].answers).asMap().entries.map((entry) {
                  int index = entry.key;
                  String answer = entry.value;

                  Color buttonColor = Colors.blueGrey; // default

                  if (answered) {
                    if (index == selectedAnswerIndex) {
                      buttonColor = (index == questions[currentQuestionIndex].correctIndex)
                          ? Colors.green
                          : Colors.red;
                    } else if (index == questions[currentQuestionIndex].correctIndex) {
                      buttonColor = Colors.green;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                          ),
                          onPressed: () {
                            if (!answered) answerQuestion(index);
                          },
                          child: Text(answer),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                if (answered)
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (questionsUnknown.contains(currentQuestionIndex)) questionsUnknown.remove(currentQuestionIndex);
                          if (questionsToReview.contains(currentQuestionIndex)) questionsToReview.remove(currentQuestionIndex);
                          questionsFinished.add(currentQuestionIndex);
                          nextQuestion();
                        },
                        child: const Text("Finish"),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (questionsUnknown.contains(currentQuestionIndex)) questionsUnknown.remove(currentQuestionIndex);
                          questionsToReview.add(currentQuestionIndex);
                          nextQuestion();
                        },
                        child: const Text("To Review"),
                      ),
                    ],
                  ),
              ],
            ),

            // Bottom Stats Row
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Unknown: ${questionsUnknown.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                  Text('To Review: ${questionsToReview.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                  Text('Finished: ${questionsFinished.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
style: GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  */