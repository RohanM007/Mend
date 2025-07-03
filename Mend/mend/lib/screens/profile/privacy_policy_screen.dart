import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            Text(
              'Last updated: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),

            _buildSection(
              context,
              'Introduction',
              'Mend ("we", "our", or "us") is committed to protecting your privacy and personal information in accordance with the Protection of Personal Information Act (POPIA) of South Africa. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mental health and wellness mobile application. Our app is designed for users aged 12 years and older, with special protections for minors under 18.',
            ),

            _buildSection(
              context,
              'Information We Collect',
              '''We collect the following types of information:

• Personal Information: Name, email address, and account credentials
• Health and Wellness Data: Mood entries, journal entries, meditation sessions, and wellness preferences
• Usage Data: App usage patterns, feature interactions, and session duration
• Device Information: Device type, operating system, and app version
• Technical Data: IP address, device identifiers, and crash reports (anonymized)''',
            ),

            _buildSection(
              context,
              'How We Use Your Information',
              '''We use your information for the following purposes:

• To provide and maintain our mental health services
• To personalize your wellness experience and recommendations
• To track your progress and provide insights
• To improve our app functionality and user experience
• To communicate with you about your account and app updates
• To ensure the security and integrity of our services
• To comply with legal obligations under South African law''',
            ),

            _buildSection(
              context,
              'Data Storage and Security',
              '''Your data is stored securely using industry-standard encryption and security measures:

• All personal data is encrypted both in transit and at rest
• We use secure cloud storage services with data centers that comply with international security standards
• Access to your data is restricted to authorized personnel only
• We implement regular security audits and monitoring
• Your sensitive health data is anonymized where possible''',
            ),

            _buildSection(
              context,
              'Your Rights Under POPIA',
              '''Under the Protection of Personal Information Act, you have the right to:

• Access your personal information we hold about you
• Request correction of inaccurate or incomplete information
• Request deletion of your personal information
• Object to the processing of your personal information
• Request restriction of processing in certain circumstances
• Data portability - receive your data in a structured format
• Withdraw consent at any time (where processing is based on consent)''',
            ),

            _buildSection(
              context,
              'Data Sharing and Disclosure',
              '''We do not sell, trade, or rent your personal information to third parties. We may share your information only in the following circumstances:

• With your explicit consent
• To comply with legal obligations or court orders
• To protect our rights, property, or safety, or that of our users
• With service providers who assist in app functionality (under strict confidentiality agreements)
• In case of business transfer or merger (with prior notice to you)''',
            ),

            _buildSection(
              context,
              'Data Retention',
              '''We retain your personal information only as long as necessary for the purposes outlined in this policy:

• Account information: Until you delete your account
• Health and wellness data: Until you request deletion or delete your account
• Usage data: Anonymized and retained for up to 2 years for improvement purposes
• Technical data: Retained for up to 1 year for security and debugging purposes''',
            ),

            _buildSection(
              context,
              'Children\'s Privacy and Parental Consent',
              '''Our app is intended for users aged 12 years and older. We take special care to protect the privacy of minors:

For Users Aged 12-17:
• Parental or guardian consent is required before creating an account
• We collect only the minimum necessary information for app functionality
• Parents/guardians have the right to review, modify, or delete their child's information
• We do not share minor's information with third parties without explicit parental consent
• Enhanced privacy protections apply to all data from users under 18

For Users Under 12:
• Our app is not intended for children under 12 years of age
• We do not knowingly collect personal information from children under 12
• If we discover we have collected information from a child under 12, we will delete it immediately

Parental Rights:
• Parents/guardians may contact us to review their child's account
• Request deletion of their child's personal information
• Withdraw consent for data processing at any time
• Receive notifications about data practices affecting their child

If you are a parent or guardian and have concerns about your child's use of our app, please contact us immediately.''',
            ),

            _buildSection(
              context,
              'Age Verification and Consent',
              '''We implement the following measures to ensure appropriate age verification and consent:

Account Creation Process:
• Users must confirm they are 12 years or older during registration
• Users aged 12-17 must provide a parent/guardian email for consent verification
• Parental consent is obtained before account activation for minors
• We verify parental identity through secure email confirmation

Ongoing Compliance:
• Regular review of accounts to ensure age compliance
• Immediate suspension of accounts found to be under 12 years old
• Clear communication with parents about their child's app usage
• Annual consent renewal for users under 18

Technical Safeguards:
• Age-appropriate content filtering for users under 18
• Enhanced privacy settings for minor accounts
• Restricted data sharing for users under 18
• Additional security measures for minor account protection''',
            ),

            _buildSection(
              context,
              'Changes to This Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app and updating the "Last updated" date. You are advised to review this Privacy Policy periodically for any changes.',
            ),

            _buildSection(
              context,
              'Contact Information',
              '''If you have any questions about this Privacy Policy or wish to exercise your rights under POPIA, please contact us:

• Email: rohanmaharaj708@gmail.com

For complaints about our handling of your personal information, you may also contact the Information Regulator of South Africa at:
• Website: www.justice.gov.za/inforeg
• Email: inforeg@justice.gov.za''',
            ),

            const SizedBox(height: AppConstants.paddingXLarge),

            Center(
              child: Text(
                'This Privacy Policy is compliant with the Protection of Personal Information Act (POPIA) of South Africa.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppConstants.paddingLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
      ],
    );
  }
}
