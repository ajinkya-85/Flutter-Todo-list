import 'package:flutter/material.dart';
import 'todo_data_service.dart';

class TodoService extends ChangeNotifier {
  final TodoDataService _dataService = TodoDataService();
  List<Map<String, dynamic>> _groups = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get groups => _groups;
  bool get isLoading => _isLoading;

  // Initialize the service
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();
      await loadAllData();
    } catch (e) {
      debugPrint('Error initializing TodoService: $e');
      _groups = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load all data from database
  Future<void> loadAllData() async {
    try {
      _isLoading = true;
      notifyListeners();
      final data = await _dataService.getAllDataForUI();
      _groups = [];
      for (var groupData in data) {
        List<Map<String, dynamic>> tasks = [];
        final tasksData = groupData['tasks'];
        if (tasksData is List) {
          for (var task in tasksData) {
            if (task is Map<String, dynamic>) {
              tasks.add(task);
            }
          }
        }
        final group = <String, dynamic>{
          'id': groupData['id'],
          'name': groupData['name'],
          'color': groupData['color'],
          'isExpanded': groupData['isExpanded'] ?? true,
          'tasks': tasks,
        };
        _groups.add(group);
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      _groups = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new group
  Future<void> addGroup(String name, Color color) async {
    try {
      final groupId = await _dataService.createGroup(name, color);
      _groups.insert(0, {
        'id': groupId,
        'name': name,
        'color': color,
        'isExpanded': true,
        'tasks': <Map<String, dynamic>>[],
      });
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding group: $e');
    }
  }

  // Add a task to a group
  Future<void> addTask(int groupIndex, String taskText, String? time) async {
    if (groupIndex >= _groups.length) return;
    try {
      final group = _groups[groupIndex];
      final taskId = await _dataService.createTask(group['id'], taskText, time);
      final newTask = <String, dynamic>{
        'id': taskId,
        'text': taskText,
        'completed': false,
        'time': time,
      };
      (group['tasks'] as List<Map<String, dynamic>>).add(newTask);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding task: $e');
    }
  }

  // Toggle task completion
  Future<void> toggleTask(int groupIndex, int taskIndex) async {
    if (groupIndex >= _groups.length) return;

    try {
      final group = _groups[groupIndex];
      final tasks = group['tasks'] as List;

      if (taskIndex >= tasks.length) return;

      final task = tasks[taskIndex] as Map<String, dynamic>;
      final newCompleted = !(task['completed'] as bool);

      await _dataService.updateTaskCompletion(task['id'], newCompleted);
      task['completed'] = newCompleted;

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling task: $e');
    }
  }

  // Remove a task
  Future<void> removeTask(int groupIndex, int taskIndex) async {
    if (groupIndex >= _groups.length) return;

    try {
      final group = _groups[groupIndex];
      final tasks = group['tasks'] as List;

      if (taskIndex >= tasks.length) return;

      final task = tasks[taskIndex] as Map<String, dynamic>;
      await _dataService.deleteTask(task['id']);
      tasks.removeAt(taskIndex);

      notifyListeners();
    } catch (e) {
      debugPrint('Error removing task: $e');
    }
  }

  // Toggle group expansion
  Future<void> toggleGroupExpansion(int groupIndex) async {
    if (groupIndex >= _groups.length) return;

    try {
      final group = _groups[groupIndex];
      final newExpanded = !(group['isExpanded'] as bool);

      await _dataService.updateGroupExpansion(group['id'], newExpanded);
      group['isExpanded'] = newExpanded;

      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling group expansion: $e');
    }
  }

  // Delete a group
  Future<void> deleteGroup(int groupIndex) async {
    if (groupIndex >= _groups.length) return;

    try {
      final group = _groups[groupIndex];
      await _dataService.deleteGroup(group['id']);
      _groups.removeAt(groupIndex);

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting group: $e');
    }
  }

  // Get completion count for a group
  int getCompletionCount(int groupIndex) {
    if (groupIndex >= _groups.length) return 0;

    try {
      final group = _groups[groupIndex];
      final tasks = group['tasks'] as List;

      int count = 0;
      for (var task in tasks) {
        if (task is Map<String, dynamic> && task['completed'] == true) {
          count++;
        }
      }
      return count;
    } catch (e) {
      debugPrint('Error getting completion count: $e');
      return 0;
    }
  }
}
