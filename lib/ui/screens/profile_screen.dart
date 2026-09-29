import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/linked_student_data.dart';
import '../../providers/auth_provider.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final linkedData = context.watch<AuthProvider>().linkedData;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        elevation: 0,
        surfaceTintColor: const Color(0xFFF3F4F6),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF111827),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthScreen()),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFFB91C1C),
            ),
          ),
        ],
      ),
      body: linkedData == null
          ? const Center(
              child: Text(
                'No profile data available.',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF4F46A5),
                          child: Text(
                            linkedData.name.isNotEmpty
                                ? linkedData.name.trim().split(' ').first[0]
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                linkedData.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                linkedData.email,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Section: ${linkedData.section}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    title: 'Profile Info',
                    entries: [
                      _InfoEntry('Name', linkedData.name),
                      _InfoEntry('Phone', linkedData.phone),
                      _InfoEntry('Sex', linkedData.sex),
                      _InfoEntry('Blood Group', linkedData.bloodGroup),
                      _InfoEntry('Batch', linkedData.batch),
                      _InfoEntry('Shift', linkedData.shift),
                      _InfoEntry('Campus', linkedData.campus),
                      _InfoEntry('Program', linkedData.program),
                      _InfoEntry('Department', linkedData.department),
                      _InfoEntry('Faculty', linkedData.faculty),
                      _InfoEntry('Issue Date', linkedData.issueDate),
                      _InfoEntry('Expire Date', linkedData.expireDate),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _PortalDashboardCard(linkedData: linkedData),
                  const SizedBox(height: 12),
                  _WaiverCard(linkedData: linkedData),
                ],
              ),
            ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<_InfoEntry> entries;

  const _InfoCard({
    required this.title,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ...entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 108,
                    child: Text(
                      entry.label,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoEntry {
  final String label;
  final String value;

  const _InfoEntry(this.label, this.value);
}

class _PortalDashboardCard extends StatelessWidget {
  final LinkedStudentData linkedData;

  const _PortalDashboardCard({required this.linkedData});

  String _currency(double value) {
    return value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    final results = linkedData.semesterWiseResult;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portal Dashboard Info',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricChip(
                  label: 'Total Payable',
                  value: _currency(linkedData.totalPayable),
                  color: const Color(0xFF1D4ED8),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricChip(
                  label: 'Total Paid',
                  value: _currency(linkedData.totalPaid),
                  color: const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MetricChip(
                  label: 'Total Due',
                  value: _currency(linkedData.totalDue),
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricChip(
                  label: 'Total Other',
                  value: _currency(linkedData.totalOther),
                  color: const Color(0xFF7C3AED),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Semester Wise Result',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(results.length, (index) {
              final result = results[index];
              final height = ((result / 4.0) * 80).clamp(12.0, 80.0);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == results.length - 1 ? 0 : 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        result.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF374151),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'S${index + 1}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaiverCard extends StatelessWidget {
  final LinkedStudentData linkedData;

  const _WaiverCard({required this.linkedData});

  String _percent(double value) {
    if (value % 1 == 0) {
      return '${value.toInt()}%';
    }
    return '${value.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waiver',
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Semester Waiver',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _WaiverEntry('Semester', linkedData.semesterWaiverSemester),
                _WaiverEntry('Waiver Rate', _percent(linkedData.semesterWaiverRate)),
                _WaiverEntry('Waiver Category', linkedData.semesterWaiverCategory),
                _WaiverEntry(
                  'Sub Category',
                  linkedData.semesterWaiverSubCategory.isEmpty
                      ? 'N/A'
                      : linkedData.semesterWaiverSubCategory,
                ),
                _WaiverEntry(
                  'Is Full Waiver',
                  linkedData.semesterWaiverIsFullWaiver ? 'Yes' : 'No',
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fixed Waiver',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _WaiverEntry('Category', linkedData.fixedWaiverCategory),
                _WaiverEntry('Waiver Rate', _percent(linkedData.fixedWaiverRate)),
                _WaiverEntry('Type', linkedData.fixedWaiverType),
                _WaiverEntry('Effective Semester', linkedData.fixedWaiverEffectiveSemester),
                _WaiverEntry('Minimum SGPA', linkedData.fixedWaiverMinimumSgpa.toStringAsFixed(2)),
                _WaiverEntry('Minimum Credit', linkedData.fixedWaiverMinimumCredit.toStringAsFixed(2)),
                _WaiverEntry('Reference Registration', linkedData.fixedWaiverReferenceRegistration),
                _WaiverEntry(
                  'Reference ID',
                  linkedData.fixedWaiverReferenceId.isEmpty ? 'N/A' : linkedData.fixedWaiverReferenceId,
                ),
                _WaiverEntry(
                  'Full Waiver',
                  linkedData.fixedWaiverFullWaiver ? 'Yes' : 'No',
                ),
                _WaiverEntry('Remarks', linkedData.fixedWaiverRemarks),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WaiverEntry extends StatelessWidget {
  final String label;
  final String value;

  const _WaiverEntry(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
