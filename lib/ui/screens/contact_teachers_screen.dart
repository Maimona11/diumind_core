import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/models/teacher_model.dart';
import '../../services/teacher_service.dart';

class ContactTeachersScreen extends StatefulWidget {
  const ContactTeachersScreen({super.key});

  @override
  State<ContactTeachersScreen> createState() => _ContactTeachersScreenState();
}

class _ContactTeachersScreenState extends State<ContactTeachersScreen> {
  final TeacherService _teacherService = TeacherService();
  final TextEditingController _searchController = TextEditingController();

  List<TeacherModel> _allTeachers = [];
  List<TeacherModel> _visibleTeachers = [];
  List<String> _departments = ['All Departments'];
  String _selectedDepartment = 'All Departments';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    final teachers = await _teacherService.fetchTeachers();
    if (!mounted) return;

    final uniqueDepartments = {
      'All Departments',
      ...teachers
          .map((e) => e.department.trim())
          .where((department) => department.isNotEmpty),
    }.toList()
      ..sort();

    if (uniqueDepartments.contains('All Departments')) {
      uniqueDepartments
        ..remove('All Departments')
        ..insert(0, 'All Departments');
    }

    setState(() {
      _allTeachers = teachers;
      _departments = uniqueDepartments;
      _isLoading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = _allTeachers.where((teacher) {
      final matchesDepartment = _selectedDepartment == 'All Departments' ||
          teacher.department == _selectedDepartment;

      final searchable =
          '${teacher.name} ${teacher.initials}'.toLowerCase();
      final matchesSearch = query.isEmpty || searchable.contains(query);

      return matchesDepartment && matchesSearch;
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    setState(() {
      _visibleTeachers = filtered;
    });
  }

  void _showTeacherDetails(TeacherModel teacher) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFCBD5E1),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${teacher.name} (${teacher.initials})',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Color(0xFF111827),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF64748B),
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(label: 'Desig', value: teacher.designation),
                  _DetailRow(label: 'ID', value: teacher.teacherId),
                  _DetailRow(
                    label: 'Cell',
                    value: teacher.cell,
                    valueColor: const Color(0xFF67A3FF),
                  ),
                  _DetailRow(label: 'Email', value: teacher.email),
                  _DetailRow(label: 'Room', value: teacher.room),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        surfaceTintColor: const Color(0xFFF3F4F6),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF111827),
          ),
        ),
        title: const Text(
          'Contact Teachers',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search by name or initials',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 156,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDepartment,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      items: _departments
                          .map(
                            (department) => DropdownMenuItem<String>(
                              value: department,
                              child: Text(
                                department,
                                style: const TextStyle(fontSize: 13.5),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedDepartment = value;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _visibleTeachers.isEmpty
                      ? const Center(
                          child: Text(
                            'No teachers found',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 15,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _visibleTeachers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final teacher = _visibleTeachers[index];
                            return Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _showTeacherDetails(teacher),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor:
                                            const Color(0xFF4F46A5),
                                        child: Text(
                                          teacher.initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${teacher.name} (${teacher.initials})',
                                              style: const TextStyle(
                                                color: Color(0xFF111827),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15.5,
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              teacher.designation,
                                              style: const TextStyle(
                                                color: Color(0xFF4B5563),
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${teacher.department} • ${teacher.room}',
                                              style: const TextStyle(
                                                color: Color(0xFF6B7280),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFF9CA3AF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF111827),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
