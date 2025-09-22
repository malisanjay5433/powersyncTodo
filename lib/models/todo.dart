/// Simple Todo model
class Todo {
  final String id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.completed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new Todo with generated ID and timestamps
  factory Todo.create({
    required String title,
    String? description,
  }) {
    final now = DateTime.now();
    return Todo(
      id: _generateId(),
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Copy with updated values
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from Map (database row)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      completed: (map['completed'] as int) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, completed: $completed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Generate a unique ID for todos
String _generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString() + 
         (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
}
