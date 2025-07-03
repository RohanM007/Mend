import 'package:flutter/material.dart';
import '../../models/mental_health_info.dart';
import '../../data/mental_health_data.dart';
import '../../constants/app_constants.dart';
import '../../widgets/mental_health_card.dart';
import '../../widgets/crisis_resources_card.dart';
import 'mental_health_detail_screen.dart';
import 'crisis_resources_screen.dart';

class MentalHealthInfoScreen extends StatefulWidget {
  const MentalHealthInfoScreen({super.key});

  @override
  State<MentalHealthInfoScreen> createState() => _MentalHealthInfoScreenState();
}

class _MentalHealthInfoScreenState extends State<MentalHealthInfoScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Info'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.emergency, color: AppConstants.errorColor),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CrisisResourcesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Crisis resources banner
          _buildCrisisBanner(),
          
          // Category filter
          _buildCategoryFilter(),
          
          // Content list
          Expanded(
            child: _buildContentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCrisisBanner() {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      child: CrisisResourcesCard(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CrisisResourcesScreen()),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      'All',
      'Anxiety',
      'Depression', 
      'Bipolar',
      'PTSD',
      'General Wellness',
    ];
    
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = selected ? category : 'All';
                });
              },
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentList() {
    final filteredInfo = _getFilteredInfo();

    if (filteredInfo.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      itemCount: filteredInfo.length,
      itemBuilder: (context, index) {
        final info = filteredInfo[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
          child: MentalHealthCard(
            info: info,
            onTap: () => _navigateToDetail(info),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology_outlined,
              size: 80,
              color: AppConstants.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              _searchQuery.isNotEmpty ? 'No results found' : 'No information available',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms or category filter.'
                  : 'Mental health information will appear here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<MentalHealthInfo> _getFilteredInfo() {
    var info = MentalHealthData.defaultMentalHealthInfo;

    // Filter by category
    if (_selectedCategory != 'All') {
      final categoryMap = {
        'Anxiety': MentalHealthCategory.anxiety,
        'Depression': MentalHealthCategory.depression,
        'Bipolar': MentalHealthCategory.bipolar,
        'PTSD': MentalHealthCategory.ptsd,
        'General Wellness': MentalHealthCategory.generalWellness,
      };
      
      final category = categoryMap[_selectedCategory];
      if (category != null) {
        info = info.where((item) => item.category == category).toList();
      }
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      info = info.where((item) {
        return item.title.toLowerCase().contains(query) ||
               item.description.toLowerCase().contains(query) ||
               item.content.toLowerCase().contains(query) ||
               item.symptoms.any((symptom) => symptom.toLowerCase().contains(query)) ||
               item.treatments.any((treatment) => treatment.toLowerCase().contains(query));
      }).toList();
    }

    return info;
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Mental Health Info'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search symptoms, conditions, treatments...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text.trim();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(MentalHealthInfo info) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MentalHealthDetailScreen(info: info),
      ),
    );
  }
}
