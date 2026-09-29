import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  String _selectedDepartment = 'All Departments';
  String _selectedCourse = 'All Courses';
  String _selectedSemester = 'All Semesters';
  String _selectedExamType = 'All Exam Types';

    static const Map<String, String> _pdfAssetPaths = {
    'System-Analysis-and-Design-(CSE),-Fall-24,-Final-watermarked.pdf':
      'questions/sad/System-Analysis-and-Design-(CSE),-Fall-24,-Final-watermarked.pdf',
    'System_Analysis_and_Design_CSE,_Spring_25,_Final_watermarked.pdf':
      'questions/sad/System_Analysis_and_Design_CSE,_Spring_25,_Final_watermarked.pdf',
    'System-Analysis-and-Design-(CSE),-Fall-25,-Final-watermarked.pdf':
      'questions/sad/System-Analysis-and-Design-(CSE),-Fall-25,-Final-watermarked.pdf',
    'System_Analysis_and_Design_CSE,_Summer_25,_Final_watermarked.pdf':
      'questions/sad/System_Analysis_and_Design_CSE,_Summer_25,_Final_watermarked.pdf',
    'Numerical-Methods-(CSE),-Spring-26-Mid.pdf':
      'questions/nm/Numerical-Methods-(CSE),-Spring-26-Mid.pdf',
    'Numerical-Methods--(CSE),-Fall-24,-Mid-watermarked.pdf':
      'questions/nm/Numerical-Methods--(CSE),-Fall-24,-Mid-watermarked.pdf',
    'Numerical-Methods--(CSE),-Summer-25,-Mid-watermarked.pdf':
      'questions/nm/Numerical-Methods--(CSE),-Summer-25,-Mid-watermarked.pdf',
    };

  late final List<String> _providedQuestionFileNames =
      _pdfAssetPaths.keys.toList()..sort();

  final Map<String, List<String>> _departmentCourses = const {
    'CSE': [
      'Algorithms',
      'Art of Living',
      'Artificial Intelligence',
      'Bangladesh Studies',
      'Compiler Design',
      'Computer Fundamentals',
      'Computer Graphics',
      'Data Communication',
      'System Analysis and Design',
    ],
    'SWE': [
      'Algorithm Design and Analysis',
      'Artificial Intelligence',
      'Business Analysis and Communication',
      'Computer Architecture',
      'Database System',
      'introduction to Robotics',
    ],
    'GEB': [
      'Animal Breeding',
      'Basic Biochemistry',
      'basic Microbiology',
      'Communicative English',
      'Metabolism',
      'Introduction to GEB',
    ],
    'EEE': [
      'Basaic Mechanical Engineering',
      'Chemistry',
      'Electrical Circuits',
      'Energy Conversion 1',
      'Physics',
      'Vector Analysis',
    ],
    'CIS': [
      'Algorythms',
      'Artificial Intelligence',
      'Big Data Analytics and Applications',
      'Computer Fundamentals',
      'Data Structures',
      'Introduction To Industry 4.0',
    ],
    'AGS': [
      'Agricultural Chemistry 1',
      'Agronomy 1',
      'Basic English',
      'Farm Power and Machinery',
      'Principles of Agroforestry',
      'Principles of Agronomy',
    ],
    'ITM': [
      'Bangladesh Studies',
      'Business Communication',
      'Business Mathematics',
      'Database management System',
      'Introduction to Finance',
      'Principles of Marketing',
    ],
    'NFE': [
      'Basic human nutrition',
      'Food chemistry',
      'Human Physiology',
      'Introduction to food science and technology',
      'Management and Marketing in food',
      'Technology of fruits and vegetables',
    ],
    'BBA': [
      'Business Law',
      'Business Mathematics',
      'Income Tax Accounting',
      'Introduction to Business',
      'Microeconomics',
      'Principal of Management',
    ],
    'CE': [
      'Computer Programming Lab',
      'Engineering Materials',
      'Fluid Mechanics',
      'Mechanics of Solids',
      'Numerical Methods',
      'Structural Analysis',
    ],
    'TE': [
      'Art of Living and Engineering Ethics',
      'Fabric Manufacturing',
      'Industrial Management',
      'Manufacturing Engineering',
      'Textile Testing and Quality Control',
      'Basic Electrical and Electronic Engineering',
    ],
    'MCT': [
      'Drawing and Sketching',
      'Structured programming',
    ],
  };

  final List<String> _baseSemesters = const [
    'Fall 26',
    'Spring 26',
    'Fall 25',
    'Summer 25',
    'Spring 25',
    'Fall 24',
    'Summer 24',
    'Spring 24',
  ];

  late final Map<String, List<String>> _departmentSemesters = {
    for (final department in _departmentCourses.keys)
      department: List<String>.from(_baseSemesters),
  };

  final List<String> _examTypes = const [
    'All Exam Types',
    'Mid Term',
    'Final',
    'Quiz',
    'Lab Final',
  ];

  String? _resolvePdfAssetPath(String fileName) {
    return _pdfAssetPaths[fileName];
  }

  Future<void> _openPdfPreview(_QuestionFileItem item) async {
    final assetPath = _resolvePdfAssetPath(item.fileName);
    if (assetPath == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF is not available yet for ${item.course}.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SizedBox(
            width: 900,
            height: 700,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Color(0xFFB91C1C)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _PdfDocumentViewer(assetPath: assetPath),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> departments = [
      'All Departments',
      ..._departmentCourses.keys,
    ];

    final effectiveDepartment = departments.contains(_selectedDepartment)
        ? _selectedDepartment
        : 'All Departments';

    final List<String> allCourses = _departmentCourses.values
        .expand((List<String> e) => e)
        .toSet()
        .toList()
      ..sort();

    final List<String> courses = effectiveDepartment == 'All Departments'
        ? [
            'All Courses',
            ...allCourses,
          ]
        : [
            'All Courses',
            ...(_departmentCourses[effectiveDepartment] ?? const <String>[]),
          ];

    final List<String> semesters = effectiveDepartment == 'All Departments'
      ? [
        'All Semesters',
        ..._baseSemesters,
        ]
      : [
        'All Semesters',
        ...(_departmentSemesters[effectiveDepartment] ?? _baseSemesters),
        ];

    final effectiveSemester = semesters.contains(_selectedSemester)
      ? _selectedSemester
      : 'All Semesters';

    final effectiveCourse =
        courses.contains(_selectedCourse) ? _selectedCourse : 'All Courses';

    final List<_QuestionFileItem> parsedFiles = _providedQuestionFileNames
      .map(_QuestionFileItem.fromFileName)
      .toList()
      ..sort((a, b) => a.fileName.compareTo(b.fileName));

    final List<_QuestionFileItem> filteredFiles = parsedFiles.where((item) {
      final departmentMatch = effectiveDepartment == 'All Departments' ||
        item.department == effectiveDepartment;
      final courseMatch =
        effectiveCourse == 'All Courses' || item.course == effectiveCourse;
      final semesterMatch = effectiveSemester == 'All Semesters' ||
        item.semester == effectiveSemester;
      final examTypeMatch = _selectedExamType == 'All Exam Types' ||
        item.examType == _selectedExamType;

      return departmentMatch && courseMatch && semesterMatch && examTypeMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7),
        elevation: 0,
        surfaceTintColor: const Color(0xFFF4F5F7),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF111827),
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Question Bank',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Browse past exam questions by department,\ncourse, semester, and exam type.',
              style: TextStyle(
                fontSize: 21,
                height: 1.45,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.filter_alt_outlined,
                          color: Color(0xFF2C67B1), size: 35),
                      SizedBox(width: 12),
                      Text(
                        'Filter Questions',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _FilterDropdown(
                    value: effectiveDepartment,
                    items: departments,
                    icon: Icons.account_balance_outlined,
                    iconColor: const Color(0xFF2C67B1),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedDepartment = value;
                        _selectedCourse = 'All Courses';
                        _selectedSemester = 'All Semesters';
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  _FilterDropdown(
                    value: effectiveCourse,
                    items: courses,
                    icon: Icons.menu_book_outlined,
                    iconColor: const Color(0xFF0F8B71),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedCourse = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  _FilterDropdown(
                    value: effectiveSemester,
                    items: semesters,
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFF8A3FB2),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedSemester = value);
                    },
                  ),
                  const SizedBox(height: 14),
                  _FilterDropdown(
                    value: _selectedExamType,
                    items: _examTypes,
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFFB45309),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedExamType = value);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Question Files',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${filteredFiles.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4C1D95),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (filteredFiles.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Text(
                  'No question files match the selected filters.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              )
            else
              ...filteredFiles.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _openPdfPreview(item),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.course,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _TagChip(text: item.department),
                                _TagChip(text: item.semester),
                                _TagChip(text: item.examType),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.fileName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PdfDocumentViewer extends StatelessWidget {
  final String assetPath;

  const _PdfDocumentViewer({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final isLinuxDesktop =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;

    // Syncfusion viewer does not provide a Linux implementation in this setup.
    if (isLinuxDesktop) {
      return FutureBuilder<Uint8List>(
        future: _loadPdfBytes(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Could not load PDF: ${snapshot.error ?? 'Unknown error'}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final bytes = snapshot.data!;
          return PdfPreview(
            build: (format) async => bytes,
            canChangePageFormat: false,
            canChangeOrientation: false,
            allowPrinting: false,
            allowSharing: false,
            useActions: false,
          );
        },
      );
    }

    return SfPdfViewer.asset(
      assetPath,
      onDocumentLoadFailed: (details) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load PDF: ${details.description}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Future<Uint8List> _loadPdfBytes(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
}

class _QuestionFileItem {
  final String fileName;
  final String department;
  final String course;
  final String semester;
  final String examType;

  const _QuestionFileItem({
    required this.fileName,
    required this.department,
    required this.course,
    required this.semester,
    required this.examType,
  });

  factory _QuestionFileItem.fromFileName(String fileName) {
    var normalized = fileName;
    if (normalized.endsWith('.pdf')) {
      normalized = normalized.substring(0, normalized.length - 4);
    }

    normalized = normalized
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .replaceAll('(', ' ')
        .replaceAll(')', ' ')
        .replaceAll('watermarked', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final parts = normalized
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    String course = parts.isNotEmpty ? parts[0] : 'Unknown Course';
    String department = 'Unknown';
    String semester = 'Unknown Semester';
    String examType = 'Unknown Exam';

    final deptMatch = RegExp(
      r'\b(CSE|SWE|GEB|EEE|CIS|AGS|ITM|NFE|BBA|CE|TE|MCT)\b',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (deptMatch != null) {
      department = deptMatch.group(1)!.toUpperCase();
    }

    final semMatch = RegExp(
      r'\b(Fall|Spring|Summer)\s+(\d{2})\b',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (semMatch != null) {
      final seasonRaw = semMatch.group(1)!;
      final season =
          '${seasonRaw[0].toUpperCase()}${seasonRaw.substring(1).toLowerCase()}';
      semester = '$season ${semMatch.group(2)!}';
    }

    final normalizedLower = normalized.toLowerCase();
    if (normalizedLower.contains('lab final')) {
      examType = 'Lab Final';
    } else if (
      normalizedLower.contains('mid term') || normalizedLower.contains(' mid')
    ) {
      examType = 'Mid Term';
    } else if (normalizedLower.contains('quiz')) {
      examType = 'Quiz';
    } else if (normalizedLower.contains('final')) {
      examType = 'Final';
    }

    // Clean course string when department may be embedded in it.
    course = course
        .replaceAll(
          RegExp(r'\b(CSE|SWE|GEB|EEE|CIS|AGS|ITM|NFE|BBA|CE|TE|MCT)\b'),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return _QuestionFileItem(
      fileName: fileName,
      department: department,
      course: course,
      semester: semester,
      examType: examType,
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;

  const _TagChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF374151),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final IconData icon;
  final Color iconColor;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.items,
    required this.icon,
    required this.iconColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 27),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.expand_more, color: Color(0xFF6B7280)),
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
