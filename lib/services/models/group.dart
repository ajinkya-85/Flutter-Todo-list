import 'package:flutter/material.dart';

class Group {
  final int? id;
  final String name;
  final Color color;
  final bool isExpanded;
  final DateTime createdAt;

  Group({
    this.id,
    required this.name,
    required this.color,
    this.isExpanded = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'isExpanded': isExpanded ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: Color(map['color'] as int),
      isExpanded: (map['isExpanded'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Group copyWith({
    int? id,
    String? name,
    Color? color,
    bool? isExpanded,
    DateTime? createdAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      isExpanded: isExpanded ?? this.isExpanded,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
