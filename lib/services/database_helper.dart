import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/group.dart';
import 'models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo_database.db');

    try {
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
      return database;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create groups table
    await db.execute('''
      CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        isExpanded INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create tasks table
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER NOT NULL,
        text TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0,
        time TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (groupId) REFERENCES groups (id) ON DELETE CASCADE
      )
    ''');
  }

  // Group operations
  Future<int> insertGroup(Group group) async {
    final db = await database;
    final result = await db.insert('groups', group.toMap());
    return result;
  }

  Future<List<Group>> getAllGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'groups',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Group.fromMap(maps[i]));
  }

  Future<int> updateGroupExpansion(int groupId, bool isExpanded) async {
    final db = await database;
    return await db.update(
      'groups',
      {'isExpanded': isExpanded ? 1 : 0},
      where: 'id = ?',
      whereArgs: [groupId],
    );
  }

  Future<int> deleteGroup(int groupId) async {
    final db = await database;
    // Delete all tasks in the group first
    await db.delete('tasks', where: 'groupId = ?', whereArgs: [groupId]);
    // Then delete the group
    return await db.delete('groups', where: 'id = ?', whereArgs: [groupId]);
  }

  // Task operations
  Future<int> insertTask(Task task) async {
    final db = await database;
    final result = await db.insert('tasks', task.toMap());
    return result;
  }

  Future<List<Task>> getTasksForGroup(int groupId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'createdAt ASC',
    );
    return List.generate(maps.length, (i) => Task.fromMap(maps[i]));
  }

  Future<int> updateTaskCompletion(int taskId, bool completed) async {
    final db = await database;
    return await db.update(
      'tasks',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<int> deleteTask(int taskId) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
  }

  // Get all data for the app
  Future<List<Map<String, dynamic>>> getAllData() async {
    final groups = await getAllGroups();

    List<Map<String, dynamic>> result = [];

    for (var group in groups) {
      final tasks = await getTasksForGroup(group.id!);
      result.add({
        'id': group.id,
        'name': group.name,
        'color': group.color,
        'isExpanded': group.isExpanded,
        'tasks': tasks
            .map(
              (task) => {
                'id': task.id,
                'text': task.text,
                'completed': task.completed,
                'time': task.time,
              },
            )
            .toList(),
      });
    }

    return result;
  }

  // Debug method to check database contents
  Future<Map<String, dynamic>> getDatabaseStats() async {
    try {
      final db = await database;

      // Get groups count
      final groupsResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM groups',
      );
      final groupsCount = groupsResult.first['count'] as int;

      // Get tasks count
      final tasksResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks',
      );
      final tasksCount = tasksResult.first['count'] as int;

      // Get completed tasks count
      final completedResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM tasks WHERE completed = 1',
      );
      final completedCount = completedResult.first['count'] as int;

      return {
        'groups': groupsCount,
        'totalTasks': tasksCount,
        'completedTasks': completedCount,
        'pendingTasks': tasksCount - completedCount,
      };
    } catch (e) {
      return {
        'groups': 0,
        'totalTasks': 0,
        'completedTasks': 0,
        'pendingTasks': 0,
      };
    }
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Check if database file exists
  Future<bool> databaseExists() async {
    try {
      String path = join(await getDatabasesPath(), 'todo_database.db');
      final file = File(path);
      final exists = await file.exists();
      return exists;
    } catch (e) {
      return false;
    }
  }

  // Get database file size
  Future<int> getDatabaseSize() async {
    try {
      String path = join(await getDatabasesPath(), 'todo_database.db');
      final file = File(path);
      if (await file.exists()) {
        final size = await file.length();
        return size;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}
