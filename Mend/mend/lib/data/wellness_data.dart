import '../models/wellness_content.dart';

class WellnessData {
  static List<Affirmation> get defaultAffirmations => [
    Affirmation(
      id: 'aff_1',
      text: 'I am worthy of love and respect, including from myself.',
      category: WellnessCategory.selfLove,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_2',
      text: 'I have the strength to overcome any challenge that comes my way.',
      category: WellnessCategory.resilience,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_3',
      text: 'I choose to focus on what I can control and let go of what I cannot.',
      category: WellnessCategory.mindfulness,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_4',
      text: 'Every day brings new opportunities for growth and happiness.',
      category: WellnessCategory.motivation,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_5',
      text: 'I am grateful for the small moments that bring me joy.',
      category: WellnessCategory.gratitude,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_6',
      text: 'My feelings are valid, and it\'s okay to take time to process them.',
      category: WellnessCategory.selfLove,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_7',
      text: 'I trust in my ability to navigate through difficult times.',
      category: WellnessCategory.resilience,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_8',
      text: 'I deserve peace and tranquility in my life.',
      category: WellnessCategory.stress,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_9',
      text: 'I am learning and growing with each experience.',
      category: WellnessCategory.motivation,
      createdAt: DateTime.now(),
    ),
    Affirmation(
      id: 'aff_10',
      text: 'I choose to be present in this moment and find beauty in it.',
      category: WellnessCategory.mindfulness,
      createdAt: DateTime.now(),
    ),
  ];

  static List<WellnessTip> get defaultWellnessTips => [
    WellnessTip(
      id: 'tip_1',
      title: '5-4-3-2-1 Grounding Technique',
      content: '''When feeling anxious or overwhelmed, try this simple grounding exercise:

• 5 things you can see
• 4 things you can touch
• 3 things you can hear
• 2 things you can smell
• 1 thing you can taste

This technique helps bring your attention back to the present moment and can reduce anxiety symptoms.''',
      category: WellnessCategory.anxiety,
      tags: ['grounding', 'anxiety', 'mindfulness'],
      readingTimeMinutes: 2,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_2',
      title: 'The Power of Deep Breathing',
      content: '''Deep breathing is one of the most effective ways to reduce stress and anxiety:

• Breathe in slowly through your nose for 4 counts
• Hold your breath for 4 counts
• Exhale slowly through your mouth for 6 counts
• Repeat 5-10 times

This activates your body's relaxation response and helps calm your nervous system.''',
      category: WellnessCategory.stress,
      tags: ['breathing', 'stress relief', 'relaxation'],
      readingTimeMinutes: 2,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_3',
      title: 'Creating a Gratitude Practice',
      content: '''Gratitude can significantly improve your mental health and overall well-being:

• Write down 3 things you're grateful for each day
• Be specific about why you're grateful
• Include small moments, not just big events
• Practice gratitude even on difficult days

Research shows that regular gratitude practice can increase happiness and reduce depression.''',
      category: WellnessCategory.gratitude,
      tags: ['gratitude', 'happiness', 'journaling'],
      readingTimeMinutes: 3,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_4',
      title: 'Building Better Sleep Habits',
      content: '''Quality sleep is essential for mental health. Try these tips:

• Keep a consistent sleep schedule
• Create a relaxing bedtime routine
• Avoid screens 1 hour before bed
• Keep your bedroom cool and dark
• Limit caffeine after 2 PM

Good sleep hygiene can improve mood, reduce anxiety, and boost cognitive function.''',
      category: WellnessCategory.sleep,
      tags: ['sleep', 'routine', 'mental health'],
      readingTimeMinutes: 3,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_5',
      title: 'Mindful Walking Meditation',
      content: '''Turn your daily walk into a mindfulness practice:

• Focus on the sensation of your feet touching the ground
• Notice your breathing rhythm
• Observe your surroundings without judgment
• When your mind wanders, gently return focus to walking

This combines physical exercise with mindfulness for double the mental health benefits.''',
      category: WellnessCategory.mindfulness,
      tags: ['mindfulness', 'walking', 'meditation'],
      readingTimeMinutes: 2,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_6',
      title: 'Setting Healthy Boundaries',
      content: '''Healthy boundaries are essential for mental wellness:

• Learn to say "no" without guilt
• Communicate your needs clearly
• Respect others' boundaries too
• Take time for yourself regularly
• Don't feel obligated to explain every decision

Boundaries protect your energy and help maintain healthy relationships.''',
      category: WellnessCategory.relationships,
      tags: ['boundaries', 'relationships', 'self-care'],
      readingTimeMinutes: 3,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_7',
      title: 'Progressive Muscle Relaxation',
      content: '''This technique helps release physical tension and mental stress:

• Start with your toes, tense for 5 seconds, then relax
• Move up through each muscle group
• Notice the difference between tension and relaxation
• End with your face and scalp
• Take deep breaths throughout

Practice this before bed or when feeling stressed.''',
      category: WellnessCategory.stress,
      tags: ['relaxation', 'stress relief', 'body awareness'],
      readingTimeMinutes: 4,
      createdAt: DateTime.now(),
    ),
    WellnessTip(
      id: 'tip_8',
      title: 'The Art of Self-Compassion',
      content: '''Treat yourself with the same kindness you'd show a good friend:

• Notice your inner critic and challenge harsh self-talk
• Practice self-forgiveness for mistakes
• Remember that everyone struggles sometimes
• Use gentle, encouraging language with yourself
• Celebrate small wins and progress

Self-compassion is linked to better mental health and resilience.''',
      category: WellnessCategory.selfLove,
      tags: ['self-compassion', 'self-love', 'mental health'],
      readingTimeMinutes: 3,
      createdAt: DateTime.now(),
    ),
  ];

  static List<DailyQuote> get inspirationalQuotes => [
    const DailyQuote(
      text: 'You are braver than you believe, stronger than you seem, and smarter than you think.',
      author: 'A.A. Milne',
      category: WellnessCategory.motivation,
    ),
    const DailyQuote(
      text: 'The present moment is the only time over which we have dominion.',
      author: 'Thích Nhất Hạnh',
      category: WellnessCategory.mindfulness,
    ),
    const DailyQuote(
      text: 'Be yourself; everyone else is already taken.',
      author: 'Oscar Wilde',
      category: WellnessCategory.selfLove,
    ),
    const DailyQuote(
      text: 'Gratitude turns what we have into enough.',
      author: 'Anonymous',
      category: WellnessCategory.gratitude,
    ),
    const DailyQuote(
      text: 'You have been assigned this mountain to show others it can be moved.',
      author: 'Mel Robbins',
      category: WellnessCategory.resilience,
    ),
    const DailyQuote(
      text: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
      category: WellnessCategory.mindfulness,
    ),
    const DailyQuote(
      text: 'Your mental health is a priority. Your happiness is essential. Your self-care is a necessity.',
      author: 'Anonymous',
      category: WellnessCategory.selfLove,
    ),
  ];

  // Get daily affirmation based on current date
  static Affirmation getDailyAffirmation() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % defaultAffirmations.length;
    return defaultAffirmations[index];
  }

  // Get daily quote based on current date
  static DailyQuote getDailyQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final index = dayOfYear % inspirationalQuotes.length;
    return inspirationalQuotes[index];
  }

  // Get random wellness tip
  static WellnessTip getRandomWellnessTip() {
    final random = DateTime.now().millisecondsSinceEpoch % defaultWellnessTips.length;
    return defaultWellnessTips[random];
  }
}
