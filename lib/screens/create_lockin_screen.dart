import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateLockInScreen extends StatefulWidget {
  const CreateLockInScreen({super.key});

  @override
  State<CreateLockInScreen> createState() => _CreateLockInScreenState();
}

class _CreateLockInScreenState extends State<CreateLockInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _punishmentController = TextEditingController();
  
  String _selectedCategory = 'Fitness';
  int _duration = 7; // days
  String _frequency = 'Daily';
  double _punishmentAmount = 10.0;
  
  final List<String> _categories = [
    'Fitness',
    'Learning',
    'Health',
    'Productivity',
    'Creative',
    'Social',
    'Other'
  ];
  
  final List<String> _frequencies = [
    'Daily',
    'Weekly',
    'Weekdays',
    'Weekends',
    'Custom'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _punishmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Create New Lock-In',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Lock-In Title*',
                hintText: 'e.g., Daily 30-minute workout',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your lock-in commitment...',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Duration
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Duration: $_duration days',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Slider(
                    value: _duration.toDouble(),
                    min: 1,
                    max: 365,
                    divisions: 52,
                    label: '$_duration days',
                    onChanged: (value) {
                      setState(() {
                        _duration = value.round();
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Frequency
            DropdownButtonFormField<String>(
              value: _frequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: _frequencies.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(frequency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _frequency = value!;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Punishment Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'Punishment Settings',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      'Amount to donate/pay if you fail: \$${_punishmentAmount.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    
                    Slider(
                      value: _punishmentAmount,
                      min: 5,
                      max: 500,
                      divisions: 99,
                      label: '\$${_punishmentAmount.toStringAsFixed(0)}',
                      onChanged: (value) {
                        setState(() {
                          _punishmentAmount = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _punishmentController,
                      decoration: const InputDecoration(
                        labelText: 'Charity/Organization (Optional)',
                        hintText: 'Where should the money go if you fail?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createLockIn,
                    child: const Text('Create Lock-In'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Info card
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• You commit to a specific goal for a set duration\n'
                      '• Check in daily/weekly to confirm completion\n'
                      '• If you miss a check-in, the punishment is triggered\n'
                      '• Your progress is shared with the community for accountability',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createLockIn() {
    if (_formKey.currentState!.validate()) {
      // Here would normally save to backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lock-In created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back to home
      context.go('/home');
    }
  }
}