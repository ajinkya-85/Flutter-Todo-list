import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/theme_provider.dart';
import 'package:todo_list/utils/database_path_helper.dart';
import 'package:todo_list/services/data_seeder.dart';
import 'package:todo_list/services/todo_service.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDark ? Colors.blue[300] : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'About Todo List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PlaywriteDEGrund',
                    color: isDark ? Colors.white : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // App Description
            Text(
              'A beautiful and intuitive todo list application built with Flutter. Organize your tasks efficiently with customizable groups, themes, and a clean interface.',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Features Section
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : null,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              '📝 Create and manage task groups',
              isDark,
            ),
            _buildFeatureItem(context, '✅ Mark tasks as completed', isDark),
            _buildFeatureItem(context, '⏰ Add time to tasks', isDark),
            _buildFeatureItem(context, '🎨 Customizable group colors', isDark),
            _buildFeatureItem(context, '🌙 Dark/Light theme support', isDark),
            _buildFeatureItem(context, '🗑️ Delete tasks and groups', isDark),
            const SizedBox(height: 20),

            // Version Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.code,
                        size: 16,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Built with Flutter & Dart',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () =>
                            DatabasePathHelper.showDatabasePath(context),
                        child: Text(
                          'Show DB Path',
                          style: TextStyle(
                            color: isDark ? Colors.blue[300] : Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () =>
                            _showSeedDatabaseDialog(context, isDark),
                        child: Text(
                          'Seed Data',
                          style: TextStyle(
                            color: isDark ? Colors.green[300] : Colors.green,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () =>
                            _showClearDatabaseDialog(context, isDark),
                        child: Text(
                          'Clear Data',
                          style: TextStyle(
                            color: isDark ? Colors.red[300] : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _refreshData(context, isDark),
                      child: Text(
                        '🔄 Refresh Data',
                        style: TextStyle(
                          color: isDark ? Colors.orange[300] : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () => _debugData(context, isDark),
                      child: Text(
                        '🐛 Debug Data',
                        style: TextStyle(
                          color: isDark ? Colors.purple[300] : Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.blue[600] : Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Close', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: isDark ? Colors.green[400] : Colors.green[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSeedDatabaseDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Text(
            'Seed Database',
            style: TextStyle(color: isDark ? Colors.white : null),
          ),
          content: Text(
            'This will add sample groups and tasks to your database. Continue?',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final todoService = Provider.of<TodoService>(
                  context,
                  listen: false,
                );
                Navigator.of(context).pop();
                final dataSeeder = DataSeeder();
                await dataSeeder.seedDatabase();

                // Refresh the UI by reloading data
                await todoService.loadAllData();

                // Show success message
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Sample data added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Seed Data'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDatabaseDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Text(
            'Clear Database',
            style: TextStyle(color: isDark ? Colors.white : null),
          ),
          content: Text(
            'This will delete ALL groups and tasks. This action cannot be undone. Continue?',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final todoService = Provider.of<TodoService>(
                  context,
                  listen: false,
                );
                Navigator.of(context).pop();
                final dataSeeder = DataSeeder();
                await dataSeeder.clearDatabase();

                // Refresh the UI by reloading data
                await todoService.loadAllData();

                // Show success message
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('🗑️ All data cleared successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _refreshData(BuildContext context, bool isDark) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final todoService = Provider.of<TodoService>(context, listen: false);
    await todoService.loadAllData();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text('🔄 Data refreshed successfully!'),
        backgroundColor: isDark ? Colors.orange[700] : Colors.orange,
      ),
    );
  }

  void _debugData(BuildContext context, bool isDark) async {
    final todoService = Provider.of<TodoService>(context, listen: false);
    final dataSeeder = DataSeeder();
    final stats = await dataSeeder.getDatabaseStats();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            title: Text(
              'Debug Information',
              style: TextStyle(color: isDark ? Colors.white : null),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Database Statistics:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Groups: ${stats['groups']}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                Text(
                  'Total Tasks: ${stats['totalTasks']}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                Text(
                  'Completed: ${stats['completedTasks']}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                Text(
                  'Pending: ${stats['pendingTasks']}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'UI State:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Groups in UI: ${todoService.groups.length}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                Text(
                  'Is Loading: ${todoService.isLoading}',
                  style: TextStyle(
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
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
}

// Helper function to show the dialog
Future<void> showAboutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AboutDialog();
    },
  );
}
