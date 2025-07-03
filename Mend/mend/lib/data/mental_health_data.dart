import '../models/mental_health_info.dart';

class MentalHealthData {
  static List<MentalHealthInfo> get defaultMentalHealthInfo => [
    // ANXIETY DISORDERS
    MentalHealthInfo(
      id: 'anxiety_overview',
      title: 'Understanding Anxiety Disorders',
      description:
          'Learn about anxiety disorders, their symptoms, and how they affect daily life.',
      category: MentalHealthCategory.anxiety,
      contentType: ContentType.overview,
      content: '''
Anxiety disorders are among the most common mental health conditions, affecting millions of people worldwide. While it's normal to feel anxious from time to time, anxiety disorders involve persistent, excessive worry that interferes with daily activities.

Anxiety is your body's natural response to stress - it's a feeling of fear or apprehension about what's to come. However, when anxiety becomes overwhelming, lasts for extended periods, or occurs without a clear trigger, it may indicate an anxiety disorder.

There are several types of anxiety disorders, including:
• Generalized Anxiety Disorder (GAD)
• Panic Disorder
• Social Anxiety Disorder
• Specific Phobias
• Agoraphobia

The good news is that anxiety disorders are highly treatable. With proper treatment, most people with anxiety disorders can learn to manage their symptoms and live fulfilling lives.
      ''',
      symptoms: [
        'Excessive worry or fear',
        'Restlessness or feeling on edge',
        'Difficulty concentrating',
        'Irritability',
        'Muscle tension',
        'Sleep problems',
        'Rapid heartbeat',
        'Sweating or trembling',
        'Shortness of breath',
        'Nausea or stomach problems',
        'Avoiding certain situations',
        'Panic attacks',
      ],
      treatments: [
        'Cognitive Behavioral Therapy (CBT)',
        'Exposure therapy',
        'Acceptance and Commitment Therapy (ACT)',
        'Medication (SSRIs, SNRIs, benzodiazepines)',
        'Mindfulness-based therapies',
        'Support groups',
        'Lifestyle changes',
      ],
      selfCareStrategies: [
        'Practice deep breathing exercises',
        'Try progressive muscle relaxation',
        'Maintain a regular exercise routine',
        'Limit caffeine and alcohol',
        'Get adequate sleep (7-9 hours)',
        'Practice mindfulness meditation',
        'Challenge negative thoughts',
        'Stay connected with supportive people',
        'Keep a worry journal',
        'Learn stress management techniques',
      ],
      warningSignsToSeekHelp: [
        'Anxiety interferes with work, school, or relationships',
        'You avoid important activities due to anxiety',
        'You experience panic attacks',
        'You use alcohol or drugs to cope',
        'You have thoughts of self-harm',
        'Physical symptoms persist despite medical evaluation',
        'You feel hopeless or depressed',
      ],
      resources: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // DEPRESSION
    MentalHealthInfo(
      id: 'depression_overview',
      title: 'Understanding Depression',
      description:
          'Learn about depression, its symptoms, and effective treatment approaches.',
      category: MentalHealthCategory.depression,
      contentType: ContentType.overview,
      content: '''
Depression is a common but serious mood disorder that affects how you feel, think, and handle daily activities. It's more than just feeling sad or going through a rough patch - it's a persistent condition that can significantly impact your quality of life.

Depression affects people differently, but it generally involves persistent feelings of sadness, hopelessness, and loss of interest in activities you once enjoyed. It can affect anyone, regardless of age, gender, or background.

Types of depression include:
• Major Depressive Disorder
• Persistent Depressive Disorder (Dysthymia)
• Bipolar Disorder
• Seasonal Affective Disorder (SAD)
• Postpartum Depression
• Psychotic Depression

Depression is highly treatable. Most people with depression feel better with medication, psychotherapy, or both. The key is finding the right treatment approach for you.
      ''',
      symptoms: [
        'Persistent sad, anxious, or empty mood',
        'Loss of interest in activities once enjoyed',
        'Feelings of hopelessness or pessimism',
        'Feelings of guilt, worthlessness, or helplessness',
        'Decreased energy or fatigue',
        'Difficulty concentrating or making decisions',
        'Sleep disturbances (insomnia or oversleeping)',
        'Appetite changes',
        'Thoughts of death or suicide',
        'Physical aches and pains',
        'Irritability',
        'Social withdrawal',
      ],
      treatments: [
        'Antidepressant medications (SSRIs, SNRIs, etc.)',
        'Psychotherapy (CBT, IPT, DBT)',
        'Electroconvulsive Therapy (ECT) for severe cases',
        'Transcranial Magnetic Stimulation (TMS)',
        'Light therapy for seasonal depression',
        'Support groups',
        'Lifestyle modifications',
      ],
      selfCareStrategies: [
        'Maintain a regular sleep schedule',
        'Exercise regularly (even light walking helps)',
        'Eat a balanced, nutritious diet',
        'Stay connected with friends and family',
        'Practice mindfulness or meditation',
        'Set small, achievable daily goals',
        'Avoid alcohol and drugs',
        'Spend time in nature',
        'Keep a mood journal',
        'Practice gratitude',
        'Engage in activities you used to enjoy',
      ],
      warningSignsToSeekHelp: [
        'Thoughts of suicide or self-harm',
        'Symptoms persist for more than two weeks',
        'Depression interferes with work or relationships',
        'You\'re using alcohol or drugs to cope',
        'You\'re unable to care for yourself',
        'You feel hopeless about the future',
        'You\'re having trouble functioning daily',
      ],
      resources: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // BIPOLAR DISORDER
    MentalHealthInfo(
      id: 'bipolar_overview',
      title: 'Understanding Bipolar Disorder',
      description:
          'Learn about bipolar disorder, mood episodes, and management strategies.',
      category: MentalHealthCategory.bipolar,
      contentType: ContentType.overview,
      content: '''
Bipolar disorder is a mental health condition characterized by extreme mood swings that include emotional highs (mania or hypomania) and lows (depression). These mood episodes can affect sleep, energy, activity, judgment, behavior, and the ability to think clearly.

There are several types of bipolar disorder:
• Bipolar I Disorder: Defined by manic episodes that last at least 7 days or are severe enough to require hospitalization
• Bipolar II Disorder: Defined by a pattern of depressive episodes and hypomanic episodes
• Cyclothymic Disorder: Periods of hypomanic symptoms and periods of depressive symptoms lasting for at least 2 years

While bipolar disorder is a lifelong condition, mood swings and symptoms can be managed with proper treatment. Most people with bipolar disorder can achieve mood stabilization and live fulfilling lives.
      ''',
      symptoms: [
        'Manic episodes: elevated mood, increased energy, decreased need for sleep',
        'Hypomanic episodes: milder form of mania',
        'Depressive episodes: persistent sadness, loss of interest',
        'Rapid speech and racing thoughts',
        'Impulsive or risky behavior',
        'Grandiose beliefs',
        'Difficulty concentrating',
        'Irritability',
        'Changes in appetite',
        'Fatigue during depressive episodes',
        'Feelings of worthlessness',
        'Thoughts of suicide',
      ],
      treatments: [
        'Mood stabilizers (lithium, anticonvulsants)',
        'Antipsychotic medications',
        'Antidepressants (used carefully)',
        'Psychotherapy (CBT, family therapy, IPSRT)',
        'Psychoeducation',
        'Support groups',
        'Lifestyle management',
      ],
      selfCareStrategies: [
        'Maintain a consistent sleep schedule',
        'Track your moods daily',
        'Take medications as prescribed',
        'Avoid alcohol and drugs',
        'Manage stress effectively',
        'Exercise regularly',
        'Eat a healthy diet',
        'Build a strong support network',
        'Learn to recognize early warning signs',
        'Practice relaxation techniques',
        'Stick to routines',
      ],
      warningSignsToSeekHelp: [
        'Thoughts of suicide or self-harm',
        'Severe manic or depressive episodes',
        'Inability to function in daily life',
        'Risky or dangerous behavior',
        'Substance abuse',
        'Psychotic symptoms',
        'Medication side effects',
      ],
      resources: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // PTSD & TRAUMA
    MentalHealthInfo(
      id: 'ptsd_overview',
      title: 'Understanding PTSD and Trauma',
      description:
          'Learn about post-traumatic stress disorder and trauma-related conditions.',
      category: MentalHealthCategory.ptsd,
      contentType: ContentType.overview,
      content: '''
Post-Traumatic Stress Disorder (PTSD) is a mental health condition that can develop after experiencing or witnessing a traumatic event. Traumatic events may include combat exposure, physical or sexual assault, accidents, natural disasters, or the sudden death of a loved one.

While it's normal to experience distress after a traumatic event, PTSD occurs when symptoms persist for more than a month and significantly impact daily functioning. Not everyone who experiences trauma will develop PTSD, and having PTSD is not a sign of weakness.

PTSD symptoms are grouped into four categories:
• Re-experiencing symptoms (flashbacks, nightmares)
• Avoidance symptoms (avoiding reminders of trauma)
• Negative alterations in mood and thinking
• Alterations in arousal and reactivity (hypervigilance, exaggerated startle response)

PTSD is treatable. Evidence-based therapies and medications can help people recover and reclaim their lives.
      ''',
      symptoms: [
        'Intrusive memories or flashbacks',
        'Nightmares about the traumatic event',
        'Severe emotional distress when reminded of trauma',
        'Avoiding thoughts, feelings, or reminders of trauma',
        'Negative thoughts about oneself or the world',
        'Persistent negative emotions',
        'Loss of interest in activities',
        'Feeling detached from others',
        'Hypervigilance',
        'Exaggerated startle response',
        'Difficulty concentrating',
        'Sleep problems',
      ],
      treatments: [
        'Trauma-focused Cognitive Behavioral Therapy',
        'Eye Movement Desensitization and Reprocessing (EMDR)',
        'Prolonged Exposure Therapy',
        'Cognitive Processing Therapy',
        'Medications (SSRIs, SNRIs)',
        'Group therapy',
        'Family therapy',
      ],
      selfCareStrategies: [
        'Practice grounding techniques',
        'Maintain social connections',
        'Exercise regularly',
        'Practice relaxation techniques',
        'Maintain a healthy sleep routine',
        'Avoid alcohol and drugs',
        'Join a support group',
        'Practice mindfulness',
        'Keep a journal',
        'Engage in meaningful activities',
        'Be patient with yourself',
      ],
      warningSignsToSeekHelp: [
        'Thoughts of suicide or self-harm',
        'Symptoms persist for more than a month',
        'Symptoms interfere with daily functioning',
        'You\'re using substances to cope',
        'You\'re having trouble maintaining relationships',
        'You\'re experiencing severe anxiety or depression',
        'You\'re having difficulty working or going to school',
      ],
      resources: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    // GENERAL WELLNESS
    MentalHealthInfo(
      id: 'wellness_overview',
      title: 'Mental Health and Wellness',
      description:
          'Learn about maintaining good mental health and building resilience.',
      category: MentalHealthCategory.generalWellness,
      contentType: ContentType.overview,
      content: '''
Mental health is just as important as physical health. It affects how we think, feel, and act. Good mental health helps you handle stress, relate to others, and make healthy choices.

Mental wellness is not just the absence of mental illness - it's a state of well-being where you can:
• Realize your own potential
• Cope with normal life stresses
• Work productively
• Contribute to your community

Building and maintaining mental wellness is an ongoing process that involves developing healthy habits, building strong relationships, and learning effective coping strategies.

Remember: It's okay to not be okay sometimes. Seeking help is a sign of strength, not weakness.
      ''',
      symptoms: [
        'Signs of good mental health:',
        'Feeling confident and positive about yourself',
        'Ability to cope with stress',
        'Maintaining healthy relationships',
        'Feeling engaged in life',
        'Having a sense of purpose',
        'Ability to adapt to change',
        'Balanced emotions',
        'Clear thinking',
        'Good sleep patterns',
        'Healthy appetite',
        'Energy for daily activities',
      ],
      treatments: [
        'Regular therapy or counseling',
        'Stress management techniques',
        'Mindfulness and meditation',
        'Regular exercise',
        'Healthy nutrition',
        'Adequate sleep',
        'Social connections',
        'Meaningful activities',
      ],
      selfCareStrategies: [
        'Practice daily self-care',
        'Maintain work-life balance',
        'Set healthy boundaries',
        'Practice gratitude',
        'Stay physically active',
        'Eat nutritious foods',
        'Get 7-9 hours of sleep',
        'Limit screen time',
        'Spend time in nature',
        'Practice deep breathing',
        'Connect with others',
        'Pursue hobbies and interests',
        'Learn new skills',
        'Volunteer or help others',
        'Practice mindfulness',
      ],
      warningSignsToSeekHelp: [
        'Persistent sadness or anxiety',
        'Extreme mood changes',
        'Withdrawal from friends and activities',
        'Significant changes in eating or sleeping',
        'Difficulty functioning at work or school',
        'Substance abuse',
        'Thoughts of self-harm',
        'Feeling overwhelmed by daily tasks',
      ],
      resources: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}
