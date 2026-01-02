import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/theme_provider.dart';

class AddTaskDialog extends StatefulWidget {
  final String groupName;
  final Color groupColor;
  final Function(String taskText, String? time) onTaskAdded;

  const AddTaskDialog({
    super.key,
    required this.groupName,
    required this.groupColor,
    required this.onTaskAdded,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _taskController = TextEditingController();
  final _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _taskController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      widget.onTaskAdded(
        _taskController.text.trim(),
        _timeController.text.trim().isEmpty
            ? null
            : _timeController.text.trim(),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
      title: Text(
        'Add Task to ${widget.groupName}',
        style: TextStyle(
          fontFamily: 'PlaywriteDEGrund',
          color: isDark ? Colors.white : const Color(0xFF535050),
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task',
                hintText: 'Enter task description',
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a task description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time (Optional)',
                hintText: 'e.g., 10:00',
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 0,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.groupColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}

// Helper function to show the dialog
Future<void> showAddTaskDialog(
  BuildContext context,
  String groupName,
  Color groupColor,
  Function(String taskText, String? time) onTaskAdded,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddTaskDialog(
        groupName: groupName,
        groupColor: groupColor,
        onTaskAdded: onTaskAdded,
      );
    },
  );
}
