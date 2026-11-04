class Student {
  int? id;
  final String name;
  final String regno;
  final double cgpa;

  Student(this.name, this.regno, this.cgpa, {this.id});

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'regno': regno,
      'cgpa': cgpa,
    };
  }

  factory Student.fromMap(Map<String, Object?> map) {
    return Student(
      map['name'] as String,
      map['regno'] as String,
      (map['cgpa'] as num).toDouble(),
      id: map['id'] as int?,
    );
  }
}
