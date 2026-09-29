class TeacherModel {
  final String id;
  final String name;
  final String initials;
  final String designation;
  final String teacherId;
  final String cell;
  final String email;
  final String room;
  final String department;

  const TeacherModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.designation,
    required this.teacherId,
    required this.cell,
    required this.email,
    required this.room,
    required this.department,
  });

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      initials: (map['initials'] ?? '').toString(),
      designation: (map['designation'] ?? '').toString(),
      teacherId: (map['teacherId'] ?? '').toString(),
      cell: (map['cell'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      room: (map['room'] ?? '').toString(),
      department: (map['department'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'initials': initials,
      'designation': designation,
      'teacherId': teacherId,
      'cell': cell,
      'email': email,
      'room': room,
      'department': department,
    };
  }
}
