import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MeditationCategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Function(bool) onSelected;

  const MeditationCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey.shade100,
      selectedColor: AppConstants.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: AppConstants.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppConstants.primaryColor : AppConstants.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
        width: isSelected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
    );
  }
}
