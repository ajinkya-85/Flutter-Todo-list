import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/group.dart';
import 'models/task.dart';

class TodoDataService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Group operations
  Future<int> createGroup(String name, Color color) async {
    final group = Group(name: name, color: color);
    return await _dbHelper.insertGroup(group);
  }

  Future<List<Group>> getAllGroups() async {
    return await _dbHelper.getAllGroups();
  }

  Future<int> updateGroupExpansion(int groupId, bool isExpanded) async {
    return await _dbHelper.updateGroupExpansion(groupId, isExpanded);
  }

  Future<int> deleteGroup(int groupId) async {
    return await _dbHelper.deleteGroup(groupId);
  }

  // Task operations
  Future<int> createTask(int groupId, String text, String? time) async {
    final task = Task(groupId: groupId, text: text, time: time);
    return await _dbHelper.insertTask(task);
  }

  Future<List<Task>> getTasksForGroup(int groupId) async {
    return await _dbHelper.getTasksForGroup(groupId);
  }

  Future<int> updateTaskCompletion(int taskId, bool completed) async {
    return await _dbHelper.updateTaskCompletion(taskId, completed);
  }

  Future<int> deleteTask(int taskId) async {
    return await _dbHelper.deleteTask(taskId);
  }

  // Combined operations for UI
  Future<List<Map<String, dynamic>>> getAllDataForUI() async {
    final groups = await getAllGroups();
    List<Map<String, dynamic>> result = [];

    for (var group in groups) {
      final tasks = await getTasksForGroup(group.id!);
      final taskMaps = tasks
          .map(
            (task) => <String, dynamic>{
              'id': task.id,
              'text': task.text,
              'completed': task.completed,
              'time': task.time,
            },
          )
          .toList();

      result.add({
        'id': group.id,
        'name': group.name,
        'color': group.color,
        'isExpanded': group.isExpanded,
        'tasks': taskMaps,
      });
    }

    return result;
  }
}
