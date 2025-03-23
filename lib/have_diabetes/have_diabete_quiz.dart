import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../diabete_options.dart';
import 'DashBoard/MyActivity/MyActivity.dart';

class HaveDiabetesDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  List<String?> _selectedAnswers = List.filled(5, null);
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  // Define the color palette
  final Color lightBlue1 = Color(0xFFAEECFF);
  final Color lightBlue2 = Color(0xFF89D0ED);
  final Color mediumBlue = Color(0xFF5EB7CF);
  final Color brightBlue = Color(0xFF5FB8DD);
  final Color paleBlue = Color(0xFFC5EDFF);

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of diabetes do you have?',
      'options': ['Type 1', 'Type 2', 'Pre diabetes']
    },
    {
      'question': 'When were you first diagnosed with diabetes?',
      'options': [
        'Less than 6 months ago',
        'Less than 1 year ago',
        '1-5 years ago',
        'Over 5 years ago'
      ]
    },
    {
      'question': 'Do you follow a specific diet to manage your diabetes?',
      'options': [
        'Yes, a doctor-recommended diet',
        'Yes, but I follow my own plan',
        'No, I eat normally',
      ]
    },
    {
      'question': 'How often do you visit a doctor or healthcare provider for diabetes check-ups?',
      'options': [
        'Every 3 months',
        'Every 6 months',
        'Once a year',
        'Rarely'
      ]
    },
    {
      'question': 'Are you taking medication to manage diabetes?',
      'options': ['Oral medication', 'Insulin', 'None']
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _updateProgressAnimation(0.0);
  }

  // Calculate the number of answered questions
  int get _answeredQuestionsCount {
    return _selectedAnswers.where((answer) => answer != null).length;
  }

  // Check if all questions are answered
  bool get _allQuestionsAnswered {
    return _selectedAnswers.every((answer) => answer != null);
  }

  // Calculate progress percentage based on answered questions
  double get _progressPercentage {
    // If all questions are answered, return 100%
    if (_allQuestionsAnswered) {
      return 1.0;
    }
    return _answeredQuestionsCount / _questions.length;
  }

  void _updateProgressAnimation(double targetProgress) {
    _progressAnimation = Tween<double>(
      begin: _currentProgress,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));

    _progressAnimationController.forward(from: 0.0);
    _currentProgress = targetProgress;
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  void _selectAnswer(String answer) {
    setState(() {
      // Check if this question was previously unanswered
      bool wasUnanswered = _selectedAnswers[_currentQuestionIndex] == null;
      _selectedAnswers[_currentQuestionIndex] = answer;

      // Update progress animation
      _updateProgressAnimation(_progressPercentage);
    });
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _goBack(BuildContext context) {
    if (_currentQuestionIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DiabeteOptions()),
      );
    } else {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _finishQuiz() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyActivityScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mediumBlue),
          onPressed: () => _goBack(context),
        ),
        title: Text(
          "Quiz ${_currentQuestionIndex + 1}",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated Progress Bar
            _buildAnimatedProgressBar(),
            SizedBox(height: 30),

            // Question Text
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Answer Buttons
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: (_questions[_currentQuestionIndex]['options'] as List<String>)
                      .map((option) {
                    bool isSelected = _selectedAnswers[_currentQuestionIndex] == option;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () => _selectAnswer(option),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? brightBlue : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: brightBlue.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              )
                            ]
                                : null,
                          ),
                          child: Text(
                            option,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: _currentQuestionIndex == 0
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button - Only show if not on first question
                  if (_currentQuestionIndex > 0)
                    _buildNavigationButton(
                      icon: Icons.arrow_back,
                      onPressed: () => _goBack(context),
                    ),

                  // Next or Finish Button
                  if (_selectedAnswers[_currentQuestionIndex] != null)
                    _buildNavigationButton(
                      icon: _currentQuestionIndex < _questions.length - 1
                          ? Icons.arrow_forward
                          : Icons.check,
                      onPressed: _currentQuestionIndex < _questions.length - 1
                          ? _goToNextQuestion
                          : _finishQuiz,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProgressBar() {
    // Calculate the percentage of answered questions
    int progressPercent = (_progressPercentage * 100).toInt();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          // Progress percentage text
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "$progressPercent%",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: brightBlue,
              ),
            ),
          ),
          // Progress bar container
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _progressAnimationController,
              builder: (context, child) {
                return Row(
                  children: [
                    // Filled part of the progress bar
                    Container(
                      width: MediaQuery.of(context).size.width *
                          _progressAnimation.value * 0.85, // Adjust for padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [lightBlue2, brightBlue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: brightBlue.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Question indicator
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_questions.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  _allQuestionsAnswered
                      ? "All Questions Answered"
                      : "$_answeredQuestionsCount/${_questions.length} Answered",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _allQuestionsAnswered ? Colors.green : brightBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: brightBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: brightBlue.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

