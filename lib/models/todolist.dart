/// Simple model class representing a TodoList
/// This follows the PowerSync documentation pattern
class TodoList {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerId;

  TodoList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
  });

  factory TodoList.fromRow(Map<String, dynamic> row) {
    return TodoList(
      id: row['id'] as String,
      name: row['name'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      ownerId: row['owner_id'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'owner_id': ownerId,
    };
  }

  TodoList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
  }) {
    return TodoList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
