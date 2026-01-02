import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/addtask.dart';
import 'package:todo_list/providers/theme_provider.dart';
import 'package:todo_list/services/todo_service.dart';

class CustomBody extends StatefulWidget {
  final ValueNotifier<Color> appBarColorNotifier;
  const CustomBody({super.key, required this.appBarColorNotifier});

  @override
  State<CustomBody> createState() => CustomBodyState();
}

class CustomBodyState extends State<CustomBody> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final theme = Theme.of(context);
    final double offset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    // You can adjust the fade distance here (e.g., 100.0)
    final double fadeDistance = 100.0;
    double t = (offset / fadeDistance).clamp(0.0, 1.0);
    final Color targetColor =
        theme.appBarTheme.backgroundColor ?? theme.primaryColor;
    final Color faded = Color.lerp(Colors.transparent, targetColor, t)!;
    widget.appBarColorNotifier.value = faded;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoService>(
      builder: (context, todoService, child) {
        try {
          final groups = todoService.groups;

          if (groups.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No groups yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first group to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              try {
                return _buildCategoryCard(groups[index], index, todoService);
              } catch (e) {
                debugPrint('Error building category card at index $index: $e');
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Text('Error loading group: $e'),
                );
              }
            },
          );
        } catch (e) {
          debugPrint('Error in CustomBody build: $e');
          return Center(child: Text('Error loading data: $e'));
        }
      },
    );
  }

  void addGroup(Map<String, dynamic> groupData) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.addGroup(groupData['name'], groupData['color']);
      if (!mounted) return;
    } catch (e) {
      // Show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating group: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void toggleGroupExpansion(int index) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.toggleGroupExpansion(index);
      if (!mounted) return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error toggling group: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void toggleTask(int groupIndex, int taskIndex) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.toggleTask(groupIndex, taskIndex);
      if (!mounted) return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error toggling task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void addTask(int groupIndex, String taskText, String? time) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.addTask(groupIndex, taskText, time);
      if (!mounted) return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void removeTask(int groupIndex, int taskIndex) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.removeTask(groupIndex, taskIndex);
      if (!mounted) return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void removeGroup(int groupIndex) async {
    try {
      final todoService = Provider.of<TodoService>(context, listen: false);
      await todoService.deleteGroup(groupIndex);
      if (!mounted) return;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing group: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteGroupDialog(
    BuildContext context,
    int groupIndex,
    String groupName,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Group',
            style: TextStyle(
              fontFamily: 'PlaywriteDEGrund',
              color: Color(0xFF535050),
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$groupName"? This action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                removeGroup(groupIndex);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> group,
    int groupIndex,
    TodoService todoService,
  ) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context);
      final isDark = themeProvider.isDarkMode;
      final color = group['color'] as Color? ?? Colors.blue;
      final isExpanded = group['isExpanded'] as bool? ?? true;

      // Safe handling of tasks data
      List<Map<String, dynamic>> tasks = [];
      final tasksRaw = group['tasks'];
      if (tasksRaw is List<Map<String, dynamic>>) {
        tasks = tasksRaw;
      }

      final completedCount = todoService.getCompletionCount(groupIndex);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey[200]!,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header with completion count and hide button
            GestureDetector(
              onTap: () => toggleGroupExpansion(groupIndex),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (group['name'] as String?) ?? 'Unknown Group',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Completed ($completedCount)',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF535050),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: isDark ? Colors.white : const Color(0xFF535050),
                    size: 20,
                  ),
                ],
              ),
            ),

            if (isExpanded) ...[
              const SizedBox(height: 12),
              // Tasks
              ...tasks.map(
                (task) => _buildTask(
                  (task['text'] as String?) ?? '',
                  color,
                  (task['completed'] as bool?) ?? false,
                  task['time'] as String?,
                  () => toggleTask(groupIndex, tasks.indexOf(task)),
                  () => removeTask(groupIndex, tasks.indexOf(task)),
                ),
              ),
              const SizedBox(height: 8),
              // Add task and delete group buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add task button
                  GestureDetector(
                    onTap: () => showAddTaskDialog(
                      context,
                      (group['name'] as String?) ?? 'Unknown Group',
                      color,
                      (taskText, time) => addTask(groupIndex, taskText, time),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.add, color: color, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Add a task',
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Delete group button
                  GestureDetector(
                    onTap: () => _showDeleteGroupDialog(
                      context,
                      groupIndex,
                      (group['name'] as String?) ?? 'Unknown Group',
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delete Group',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      debugPrint('Error building category card: $e');
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red, width: 1),
        ),
        child: Text('Error loading group: $e'),
      );
    }
  }

  Widget _buildTask(
    String taskText,
    Color color,
    bool isCompleted,
    String? time,
    VoidCallback onTap,
    VoidCallback? onDelete,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: color, size: 12)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF535050),
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  children: [
                    TextSpan(text: taskText),
                    if (time != null) ...[
                      TextSpan(
                        text: ' $time',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
