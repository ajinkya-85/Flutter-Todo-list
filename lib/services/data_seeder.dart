import 'package:flutter/material.dart';
import 'todo_data_service.dart';
import 'database_helper.dart';

class DataSeeder {
  final TodoDataService _dataService = TodoDataService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Sample data for demonstration
  static const List<Map<String, dynamic>> sampleGroups = [
    {
      'name': 'Work Tasks',
      'color': Colors.blue,
      'tasks': [
        {
          'text': 'Review project proposal',
          'time': '09:00',
          'completed': false,
        },
        {'text': 'Team meeting', 'time': '11:00', 'completed': true},
        {'text': 'Update documentation', 'time': '14:00', 'completed': false},
        {'text': 'Code review', 'time': '16:00', 'completed': false},
      ],
    },
    {
      'name': 'Personal',
      'color': Colors.green,
      'tasks': [
        {'text': 'Buy groceries', 'time': '18:00', 'completed': false},
        {'text': 'Call mom', 'time': '19:00', 'completed': true},
        {'text': 'Read book', 'time': '20:00', 'completed': false},
      ],
    },
    {
      'name': 'Shopping',
      'color': Colors.orange,
      'tasks': [
        {'text': 'Milk', 'time': null, 'completed': true},
        {'text': 'Bread', 'time': null, 'completed': false},
        {'text': 'Eggs', 'time': null, 'completed': false},
        {'text': 'Vegetables', 'time': null, 'completed': false},
      ],
    },
    {
      'name': 'Health & Fitness',
      'color': Colors.red,
      'tasks': [
        {'text': 'Morning workout', 'time': '07:00', 'completed': true},
        {'text': 'Drink water', 'time': '12:00', 'completed': false},
        {'text': 'Evening walk', 'time': '18:30', 'completed': false},
        {'text': 'Take vitamins', 'time': '21:00', 'completed': false},
      ],
    },
    {
      'name': 'Learning',
      'color': Colors.purple,
      'tasks': [
        {'text': 'Flutter tutorial', 'time': '15:00', 'completed': false},
        {'text': 'Practice coding', 'time': '16:30', 'completed': false},
        {'text': 'Read tech blog', 'time': '22:00', 'completed': true},
      ],
    },
  ];

  // Seed the database with sample data
  Future<void> seedDatabase() async {
    try {
      for (var groupData in sampleGroups) {
        // Create group
        final groupId = await _dataService.createGroup(
          groupData['name'],
          groupData['color'],
        );

        // Create tasks for this group
        final tasksRaw = groupData['tasks'];
        if (tasksRaw is List) {
          for (var taskData in tasksRaw) {
            if (taskData is Map<String, dynamic>) {
              final taskId = await _dataService.createTask(
                groupId,
                taskData['text'],
                taskData['time'],
              );

              // If task is completed, update its status
              if (taskData['completed'] == true) {
                await _dataService.updateTaskCompletion(taskId, true);
              }
            }
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Clear all data from database
  Future<void> clearDatabase() async {
    try {
      // Get all groups
      final groups = await _dataService.getAllGroups();

      // Delete each group (this will also delete associated tasks due to foreign key cascade)
      for (var group in groups) {
        await _dataService.deleteGroup(group.id!);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Check if database is empty
  Future<bool> isDatabaseEmpty() async {
    try {
      final groups = await _dataService.getAllGroups();
      return groups.isEmpty;
    } catch (e) {
      return true;
    }
  }

  // Get database statistics
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      return await _dbHelper.getDatabaseStats();
    } catch (e) {
      return {
        'groups': 0,
        'totalTasks': 0,
        'completedTasks': 0,
        'pendingTasks': 0,
      };
    }
  }
}
