import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock/mock_data.dart';
import '../../data/models/linked_student_data.dart';
import '../../providers/auth_provider.dart';

class UpcomingEventsScreen extends StatelessWidget {
  const UpcomingEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = MockData.events;
    final linkedData = context.watch<AuthProvider>().linkedData;
    final List<LinkedUpcomingEvent> linkedEvents =
        linkedData?.upcomingEvents ?? const <LinkedUpcomingEvent>[];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 22,
                            color: Color(0xFF111827),
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF5A8FE0),
                            Color(0xFF608CE5),
                            Color(0xFF6B73CF),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Latest Updates',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 38),
                            child: Text(
                              linkedEvents.isEmpty
                                  ? 'No linked upcoming events found.\nCheck back later! ⭐'
                                  : '${linkedEvents.length} linked event${linkedEvents.length > 1 ? 's' : ''} updated.\nSee details below. ⭐',
                              style: const TextStyle(
                                color: Color(0xFFEAF1FF),
                                fontSize: 13,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (linkedEvents.isEmpty && events.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text(
                            'No upcoming events available.',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    else if (linkedEvents.isNotEmpty)
                      ...List.generate(linkedEvents.length, (index) {
                        final item = linkedEvents[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == linkedEvents.length - 1 ? 0 : 12,
                          ),
                          child: _EventCard(
                            title: item.title,
                            subtitle: item.syllabus.isEmpty
                                ? item.during
                                : 'Syllabus: ${item.syllabus}',
                            updatedOn: item.during,
                            dateLabel: 'Date',
                            dateValue: item.date,
                            icon: item.title.toLowerCase().contains('quiz')
                                ? Icons.quiz_outlined
                                : Icons.present_to_all_outlined,
                          ),
                        );
                      })
                    else ...[
                      if (events.isNotEmpty)
                        _EventCard(
                          title: 'CSE 3302 - Assignment 2',
                          subtitle: 'Database Normalization',
                          updatedOn: 'Updated on Mon, Apr 22',
                          dateLabel: 'Deadline',
                          dateValue: 'Apr 24, 2024',
                          icon: Icons.assignment_outlined,
                        ),
                      const SizedBox(height: 12),
                      _EventCard(
                        title: 'CSE 3302 - Presentation',
                        subtitle: 'Normalization Techniques',
                        updatedOn: 'Updated on Mon, Apr 22',
                        dateLabel: 'Date',
                        dateValue: 'Apr 26, 2024',
                        icon: Icons.present_to_all_outlined,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F4),
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E5EB)),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _BottomIconLabel(icon: Icons.home_outlined, label: 'Home'),
                      _BottomIconLabel(
                        icon: Icons.chat_bubble_outline,
                        label: 'chats',
                      ),
                      _BottomIconLabel(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                      ),
                    ],
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

class _EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String updatedOn;
  final String dateLabel;
  final String dateValue;
  final IconData icon;

  const _EventCard({
    required this.title,
    required this.subtitle,
    required this.updatedOn,
    required this.dateLabel,
    required this.dateValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 28, color: const Color(0xFF4F46A5)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 17,
                      color: Color(0xFF53A26D),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      updatedOn,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.event_note_outlined,
                      size: 20,
                      color: Color(0xFF4B5563),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$dateLabel: $dateValue',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomIconLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BottomIconLabel({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 34, color: Colors.black87),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
