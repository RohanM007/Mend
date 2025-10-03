import 'package:cloud_firestore/cloud_firestore.dart';

enum MentalHealthCategory {
  anxiety,
  depression,
  bipolar,
  ptsd,
  ocd,
  adhd,
  eatingDisorders,
  substanceAbuse,
  personalityDisorders,
  schizophrenia,
  generalWellness,
}

enum ContentType {
  overview,
  symptoms,
  diagnosis,
  treatment,
  selfCare,
  resources,
}

class MentalHealthInfo {
  final String id;
  final String title;
  final String description;
  final MentalHealthCategory category;
  final ContentType contentType;
  final String content;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> selfCareStrategies;
  final List<String> warningSignsToSeekHelp;
  final List<String> resources;
  final String? imageUrl;
  final bool isEmergencyInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  MentalHealthInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.contentType,
    required this.content,
    this.symptoms = const [],
    this.treatments = const [],
    this.selfCareStrategies = const [],
    this.warningSignsToSeekHelp = const [],
    this.resources = const [],
    this.imageUrl,
    this.isEmergencyInfo = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'contentType': contentType.toString().split('.').last,
      'content': content,
      'symptoms': symptoms,
      'treatments': treatments,
      'selfCareStrategies': selfCareStrategies,
      'warningSignsToSeekHelp': warningSignsToSeekHelp,
      'resources': resources,
      'imageUrl': imageUrl,
      'isEmergencyInfo': isEmergencyInfo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create from Firestore document
  factory MentalHealthInfo.fromMap(Map<String, dynamic> map, String id) {
    return MentalHealthInfo(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: MentalHealthCategory.values.firstWhere(
        (e) => e.toString().split('.').last == map['category'],
        orElse: () => MentalHealthCategory.generalWellness,
      ),
      contentType: ContentType.values.firstWhere(
        (e) => e.toString().split('.').last == map['contentType'],
        orElse: () => ContentType.overview,
      ),
      content: map['content'] ?? '',
      symptoms: List<String>.from(map['symptoms'] ?? []),
      treatments: List<String>.from(map['treatments'] ?? []),
      selfCareStrategies: List<String>.from(map['selfCareStrategies'] ?? []),
      warningSignsToSeekHelp: List<String>.from(
        map['warningSignsToSeekHelp'] ?? [],
      ),
      resources: List<String>.from(map['resources'] ?? []),
      imageUrl: map['imageUrl'],
      isEmergencyInfo: map['isEmergencyInfo'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Copy with method for updates
  MentalHealthInfo copyWith({
    String? id,
    String? title,
    String? description,
    MentalHealthCategory? category,
    ContentType? contentType,
    String? content,
    List<String>? symptoms,
    List<String>? treatments,
    List<String>? selfCareStrategies,
    List<String>? warningSignsToSeekHelp,
    List<String>? resources,
    String? imageUrl,
    bool? isEmergencyInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MentalHealthInfo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      contentType: contentType ?? this.contentType,
      content: content ?? this.content,
      symptoms: symptoms ?? this.symptoms,
      treatments: treatments ?? this.treatments,
      selfCareStrategies: selfCareStrategies ?? this.selfCareStrategies,
      warningSignsToSeekHelp:
          warningSignsToSeekHelp ?? this.warningSignsToSeekHelp,
      resources: resources ?? this.resources,
      imageUrl: imageUrl ?? this.imageUrl,
      isEmergencyInfo: isEmergencyInfo ?? this.isEmergencyInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get category display name
  String get categoryDisplayName {
    switch (category) {
      case MentalHealthCategory.anxiety:
        return 'Anxiety Disorders';
      case MentalHealthCategory.depression:
        return 'Depression';
      case MentalHealthCategory.bipolar:
        return 'Bipolar Disorder';
      case MentalHealthCategory.ptsd:
        return 'PTSD & Trauma';
      case MentalHealthCategory.ocd:
        return 'OCD';
      case MentalHealthCategory.adhd:
        return 'ADHD';
      case MentalHealthCategory.eatingDisorders:
        return 'Eating Disorders';
      case MentalHealthCategory.substanceAbuse:
        return 'Substance Abuse';
      case MentalHealthCategory.personalityDisorders:
        return 'Personality Disorders';
      case MentalHealthCategory.schizophrenia:
        return 'Schizophrenia';
      case MentalHealthCategory.generalWellness:
        return 'General Wellness';
    }
  }

  // Get content type display name
  String get contentTypeDisplayName {
    switch (contentType) {
      case ContentType.overview:
        return 'Overview';
      case ContentType.symptoms:
        return 'Symptoms';
      case ContentType.diagnosis:
        return 'Diagnosis';
      case ContentType.treatment:
        return 'Treatment';
      case ContentType.selfCare:
        return 'Self-Care';
      case ContentType.resources:
        return 'Resources';
    }
  }

  // Get estimated reading time
  int get readingTimeMinutes {
    final wordCount =
        content.split(' ').length +
        symptoms.join(' ').split(' ').length +
        treatments.join(' ').split(' ').length +
        selfCareStrategies.join(' ').split(' ').length;
    return (wordCount / 200).ceil(); // Average 200 words per minute
  }
}

// Crisis resources and emergency information
class CrisisResource {
  final String name;
  final String phoneNumber;
  final String description;
  final String? website;
  final bool isAvailable24_7;
  final String country;

  const CrisisResource({
    required this.name,
    required this.phoneNumber,
    required this.description,
    this.website,
    this.isAvailable24_7 = true,
    this.country = 'US',
  });

  static const List<CrisisResource> defaultCrisisResources = [
    // SOUTH AFRICAN CRISIS RESOURCES
    CrisisResource(
      name: 'South African Depression and Anxiety Group (SADAG)',
      phoneNumber: '0800 567 567',
      description:
          'Free mental health helpline providing support, counseling, and referrals. Available 8am-8pm daily.',
      website: 'https://www.sadag.org',
      isAvailable24_7: false,
      country: 'ZA',
    ),
    CrisisResource(
      name: 'SADAG Suicide Crisis Line',
      phoneNumber: '0800 567 567',
      description:
          'Dedicated suicide prevention and crisis intervention helpline. Trained counselors available.',
      website: 'https://www.sadag.org',
      country: 'ZA',
    ),
    CrisisResource(
      name: 'Lifeline Southern Africa',
      phoneNumber: '0861 322 322',
      description:
          '24-hour crisis helpline providing emotional support and suicide prevention services.',
      website: 'https://www.lifeline.org.za',
      country: 'ZA',
    ),
    CrisisResource(
      name: 'Childline South Africa',
      phoneNumber: '116',
      description:
          'Free 24-hour helpline for children and teens in crisis. Also supports adults concerned about children.',
      website: 'https://www.childlinesa.org.za',
      country: 'ZA',
    ),
    CrisisResource(
      name: 'Adcock Ingram Depression and Anxiety Helpline',
      phoneNumber: '0800 70 80 90',
      description:
          'Professional counseling and support for depression and anxiety. Available 8am-8pm weekdays.',
      isAvailable24_7: false,
      country: 'ZA',
    ),
    CrisisResource(
      name: 'Mental Health Information Centre',
      phoneNumber: '021 938 9229',
      description:
          'Information and referrals for mental health services across South Africa.',
      website: 'https://www.mentalhealthsa.co.za',
      isAvailable24_7: false,
      country: 'ZA',
    ),
    // INTERNATIONAL RESOURCES (for reference)
    CrisisResource(
      name: 'International Association for Suicide Prevention',
      phoneNumber: 'Visit website for local numbers',
      description:
          'Global directory of crisis centers and suicide prevention resources.',
      website: 'https://www.iasp.info/resources/Crisis_Centres',
      isAvailable24_7: false,
      country: 'International',
    ),
  ];
}

// Professional help finder
class ProfessionalResource {
  final String type;
  final String description;
  

  const ProfessionalResource({
    required this.type,
    required this.description,
   
  });

  static const List<ProfessionalResource> professionalResources = [
    ProfessionalResource(
      type: 'Psychiatrist',
      description:
          'Medical doctor who specializes in mental health and can prescribe medication.',
      
    ),
    ProfessionalResource(
      type: 'Clinical Psychologist',
      description:
          'Mental health professional who provides therapy and psychological assessments.',
      
    ),
    ProfessionalResource(
      type: 'Counselling Psychologist',
      description:
          'Mental health professional specializing in counseling and therapy services.',
     
    ),
    ProfessionalResource(
      type: 'General Practitioner (GP)',
      description:
          'Your family doctor who can provide initial mental health screening and referrals.',
     
    ),
    ProfessionalResource(
      type: 'Social Worker',
      description:
          'Professional who provides counseling and connects you with community resources.',
     
    ),

    ProfessionalResource(
    type: 'Psychiatric Nurse / Mental Health Nurse',
    description:
        'A Registered Nurse with specialized training in mental health. They provide direct care, monitor patients, administer medication, educate individuals and families, and help manage acute and chronic mental health conditions.',
  ),
  ProfessionalResource(
    type: 'Occupational Therapist',
    description:
        'A professional who helps individuals develop, recover, or maintain the skills needed for daily living and working (their "occupations"). They use meaningful activities and routines to support mental health, independence, and social participation.',
  ),
 

  ];
}
