import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pocketbase/pocketbase.dart';

import '../data/mock/default_teachers.dart';
import '../data/models/teacher_model.dart';

class TeacherService {
  TeacherService() {
    final baseUrl = dotenv.env['POCKETBASE_URL'] ?? '';
    if (baseUrl.trim().isNotEmpty) {
      _pb = PocketBase(baseUrl);
    }
  }

  PocketBase? _pb;

  bool get isPocketBaseConfigured => _pb != null;

  Future<void> seedDefaultTeachersIfNeeded() async {
    if (_pb == null) return;

    try {
      final existing = await _pb!.collection('teachers').getFullList();
      if (existing.isNotEmpty) {
        return;
      }

      for (final teacher in defaultTeachers) {
        await _pb!.collection('teachers').create(body: teacher.toMap());
      }
    } catch (_) {
      // Keep app functional when collection is not yet created or server is unavailable.
    }
  }

  Future<List<TeacherModel>> fetchTeachers() async {
    await seedDefaultTeachersIfNeeded();

    if (_pb == null) {
      return _sorted(defaultTeachers);
    }

    try {
      final records = await _pb!.collection('teachers').getFullList(
            sort: 'name',
          );

      final teachers = records
          .map(
            (record) => TeacherModel.fromMap({
              'id': record.id,
              ...record.data,
            }),
          )
          .toList();

      if (teachers.isEmpty) {
        return _sorted(defaultTeachers);
      }

      return _sorted(teachers);
    } catch (_) {
      return _sorted(defaultTeachers);
    }
  }

  List<TeacherModel> _sorted(List<TeacherModel> teachers) {
    final items = [...teachers];
    items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return items;
  }
}
