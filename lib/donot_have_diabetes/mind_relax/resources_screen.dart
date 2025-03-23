import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatelessWidget {
  final String depressionLevel;

  const ResourcesScreen({
    Key? key,
    required this.depressionLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5EDFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5EB7CF),
        title: const Text('Mental Health Resources'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _getHeaderText(depressionLevel),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getSubheaderText(depressionLevel),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Good Living Tips Section (NEW)
                const Text(
                  'Good Living Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                ResourceCard(
                  title: 'Healthy Eating Habits',
                  description: 'Nutrition tips for better mental health and wellbeing',
                  actionText: 'View Tips',
                  icon: Icons.restaurant,
                  color: Colors.green.shade600,
                  onTap: () => _showHealthyEatingTips(context),
                ),
                
                ResourceCard(
                  title: 'Physical Activity',
                  description: 'Simple exercises to boost your mood and energy',
                  actionText: 'Get Moving',
                  icon: Icons.directions_run,
                  color: Colors.orange.shade600,
                  onTap: () => _showPhysicalActivityTips(context),
                ),
                
                ResourceCard(
                  title: 'Social Connections',
                  description: 'Building and maintaining meaningful relationships',
                  actionText: 'Learn More',
                  icon: Icons.people,
                  color: Colors.blue.shade600,
                  onTap: () => _showSocialConnectionTips(context),
                ),
                
                ResourceCard(
                  title: 'Daily Routines',
                  description: 'Establishing healthy habits and consistent schedules',
                  actionText: 'View Routines',
                  icon: Icons.schedule,
                  color: Colors.purple.shade600,
                  onTap: () => _showDailyRoutineTips(context),
                ),
                
                const SizedBox(height: 24),
                
                
                
                // Self-Help Resources
                const Text(
                  'Self-Help Resources',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                ResourceCard(
                  title: 'Meditation Techniques',
                  description: 'Learn simple meditation practices to reduce stress',
                  actionText: 'View Techniques',
                  icon: Icons.self_improvement,
                  color: Colors.teal.shade400,
                  onTap: () => _showMeditationTechniques(context),
                ),
                
                ResourceCard(
                  title: 'Sleep Hygiene Tips',
                  description: 'Improve your sleep quality with these evidence-based tips',
                  actionText: 'View Tips',
                  icon: Icons.nightlight_round,
                  color: Colors.indigo.shade400,
                  onTap: () => _showSleepTips(context),
                ),
                
                ResourceCard(
                  title: 'Mood Journal',
                  description: 'Track your mood patterns and identify triggers',
                  actionText: 'Start Journaling',
                  icon: Icons.book,
                  color: Colors.green.shade400,
                  onTap: () => _showJournalingTips(context),
                ),
                
                const SizedBox(height: 24),
                
                //Educational Resources
                const Text(
                  'Learn More',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                
                ResourceCard(
                  title: 'Healthy Coping Strategies',
                  description: 'Effective ways to manage stress and difficult emotions',
                  actionText: 'View Strategies',
                  icon: Icons.healing,
                  color: Colors.cyan.shade700,
                  onTap: () => _showCopingStrategies(context),
                ),
                
                const SizedBox(height: 30),
                
                // Disclaimer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    'Disclaimer: These resources are provided for informational purposes only and are not a substitute for professional medical advice, diagnosis, or treatment.',
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _getHeaderText(String level) {
    switch (level) {
      case 'High':
        return 'Resources for Managing Significant Depression Symptoms';
      case 'Medium':
        return 'Resources for Improving Your Mental Wellbeing';
      case 'Low':
        return 'Resources for Maintaining Good Mental Health';
      default:
        return 'Mental Health Resources';
    }
  }
  
  String _getSubheaderText(String level) {
    switch (level) {
      case 'High':
        return 'These resources may help, but please consider professional support';
      case 'Medium':
        return 'Explore these resources to help manage your symptoms';
      case 'Low':
        return 'Keep up the good work with these helpful resources';
      default:
        return 'Resources for everyone';
    }
  }
  
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
  
  // New methods for Good Living Tips
  void _showHealthyEatingTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Healthy Eating Tips',
      [
        'Eat regular meals to maintain stable blood sugar levels',
        'Include protein with each meal to support neurotransmitter production',
        'Consume omega-3 fatty acids (fish, walnuts, flaxseeds) for brain health',
        'Limit processed foods, sugar, and caffeine which can affect mood',
        'Stay hydrated - even mild dehydration can affect your mood and energy',
        'Include plenty of fruits and vegetables for essential nutrients',
        'Consider foods rich in vitamin D, B vitamins, and magnesium',
        'Practice mindful eating - pay attention to hunger cues and enjoy your food'
      ],
    );
  }
  
  void _showPhysicalActivityTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Physical Activity Tips',
      [
        'Aim for at least 30 minutes of moderate activity most days',
        'Walking is excellent exercise - try a 10-minute walk to start',
        'Find activities you enjoy so you are more likely to continue',
        'Consider yoga or tai chi which combine movement with mindfulness',
        'Strength training helps boost mood and energy levels',
        'Outdoor activities provide additional benefits from sunlight and nature',
        'Start small and gradually increase duration and intensity',
        'Remember that any movement is better than none',
        'Consider exercise as a form of self-care rather than punishment'
      ],
    );
  }
  
  void _showSocialConnectionTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Social Connection Tips',
      [
        'Schedule regular check-ins with friends and family',
        'Join groups based on your interests to meet like-minded people',
        'Volunteer for causes you care about to connect with others',
        'Practice active listening in your conversations',
        'Be vulnerable and authentic in your relationships',
        'Set healthy boundaries to protect your energy',
        'Reach out when you need support rather than isolating',
        'Consider support groups if you are going through specific challenges',
        'Quality of connections matters more than quantity'
      ],
    );
  }
  
  void _showDailyRoutineTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Daily Routine Tips',
      [
        'Wake up and go to bed at consistent times',
        'Start your day with a positive morning routine',
        'Include time for self-care activities every day',
        'Take regular breaks during work or study periods',
        'Spend some time outdoors daily, especially in natural settings',
        'Limit screen time, particularly before bedtime',
        'Create evening wind-down routines to signal your body it is time to rest',
        'Plan your most challenging tasks during your peak energy times',
        'Include moments of mindfulness throughout your day',
        'Balance productivity with rest and leisure activities'
      ],
    );
  }
  
  void _showMeditationTechniques(BuildContext context) {
    _showResourceDialog(
      context,
      'Meditation Techniques',
      [
        'Deep Breathing: Inhale for 4 counts, hold for 4, exhale for 6',
        'Body Scan: Focus attention on each part of your body from toes to head',
        'Mindful Observation: Focus on observing an object for 5 minutes',
        'Loving-Kindness: Direct positive thoughts toward yourself and others',
        'Guided Meditation: Use apps like Headspace or Calm for guided sessions'
      ],
    );
  }
  
  void _showSleepTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Sleep Hygiene Tips',
      [
        'Maintain a consistent sleep schedule, even on weekends',
        'Create a restful environment (dark, quiet, comfortable temperature)',
        'Avoid screens at least 1 hour before bedtime',
        'Limit caffeine and alcohol, especially in the afternoon and evening',
        'Exercise regularly, but not too close to bedtime',
        'Develop a relaxing pre-sleep routine (reading, bath, gentle stretching)'
      ],
    );
  }
  
  void _showJournalingTips(BuildContext context) {
    _showResourceDialog(
      context,
      'Mood Journaling Tips',
      [
        'Record your mood at different times throughout the day',
        'Note what you were doing when mood changes occurred',
        'Track sleep, diet, exercise, and medication',
        'Write down thoughts associated with different moods',
        'Identify patterns and triggers over time',
        'Bring your journal to therapy appointments to discuss patterns'
      ],
    );
  }
  
 
  
  void _showCopingStrategies(BuildContext context) {
    _showResourceDialog(
      context,
      'Healthy Coping Strategies',
      [
        'Physical activity: Even short walks can improve mood',
        'Creative expression: Art, music, writing, or other creative outlets',
        'Social connection: Reach out to supportive friends or family',
        'Mindfulness practices: Stay present rather than worrying about past/future',
        'Gratitude practice: Note three things you are grateful for each day',
        'Limit news and social media consumption',
        'Break large tasks into smaller, manageable steps',
        'Practice self-compassion and avoid self-criticism'
      ],
    );
  }
  
  void _showResourceDialog(BuildContext context, String title, List<String> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(item)),
                  ],
                ),
              )).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ResourceCard({
    Key? key,
    required this.title,
    required this.description,
    required this.actionText,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}