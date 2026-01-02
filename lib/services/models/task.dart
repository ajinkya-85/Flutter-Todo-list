class Task {
  final int? id;
  final int groupId;
  final String text;
  final bool completed;
  final String? time;
  final DateTime createdAt;

  Task({
    this.id,
    required this.groupId,
    required this.text,
    this.completed = false,
    this.time,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'text': text,
      'completed': completed ? 1 : 0,
      'time': time,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      groupId: map['groupId'] as int,
      text: map['text'] as String,
      completed: (map['completed'] as int) == 1,
      time: map['time'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Task copyWith({
    int? id,
    int? groupId,
    String? text,
    bool? completed,
    String? time,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      text: text ?? this.text,
      completed: completed ?? this.completed,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
