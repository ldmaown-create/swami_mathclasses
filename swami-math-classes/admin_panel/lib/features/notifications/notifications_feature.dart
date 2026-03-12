import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class NotificationsFeature extends StatefulWidget {
  const NotificationsFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  State<NotificationsFeature> createState() => _NotificationsFeatureState();
}

class _NotificationsFeatureState extends State<NotificationsFeature> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  NotificationTarget _target = NotificationTarget.allStudents;
  String? _courseTarget;
  String? _studentTarget;
  bool _scheduled = false;
  DateTime? _scheduledAt;

  @override
  void initState() {
    super.initState();
    _courseTarget = widget.store.courses.first.name;
    _studentTarget = widget.store.students.first.name;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminPageContainer(
      child: ListView(
        children: [
          const SectionHeader(
            title: 'Notification Management',
            subtitle: 'Compose announcements, target recipients, and schedule delivery with static preview states.',
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compose Message',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _messageController,
                        maxLines: 5,
                        decoration: const InputDecoration(labelText: 'Message'),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<NotificationTarget>(
                        segments: const [
                          ButtonSegment(value: NotificationTarget.allStudents, label: Text('All Students')),
                          ButtonSegment(value: NotificationTarget.course, label: Text('Specific Course')),
                          ButtonSegment(value: NotificationTarget.individual, label: Text('Individual')),
                        ],
                        selected: {_target},
                        onSelectionChanged: (value) => setState(() => _target = value.first),
                      ),
                      const SizedBox(height: 16),
                      if (_target == NotificationTarget.course)
                        DropdownButtonFormField<String>(
                          value: _courseTarget,
                          decoration: const InputDecoration(labelText: 'Course Target'),
                          items: widget.store.courses
                              .map(
                                (course) => DropdownMenuItem(
                                  value: course.name,
                                  child: Text(course.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _courseTarget = value),
                        ),
                      if (_target == NotificationTarget.individual)
                        DropdownButtonFormField<String>(
                          value: _studentTarget,
                          decoration: const InputDecoration(labelText: 'Student Target'),
                          items: widget.store.students
                              .map(
                                (student) => DropdownMenuItem(
                                  value: student.name,
                                  child: Text(student.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _studentTarget = value),
                        ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _scheduled,
                        title: const Text('Schedule delivery'),
                        onChanged: (value) => setState(() => _scheduled = value),
                      ),
                      if (_scheduled)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _scheduledAt == null
                                ? 'No schedule selected'
                                : 'Scheduled for ${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year}',
                          ),
                          trailing: TextButton(
                            onPressed: () async {
                              final selected = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now().add(const Duration(days: 1)),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030),
                              );
                              if (selected != null) {
                                setState(() => _scheduledAt = selected);
                              }
                            },
                            child: const Text('Pick Date'),
                          ),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: AccentButton(
                          label: 'Send Notification',
                          icon: Icons.send_outlined,
                          onPressed: _sendNotification,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery History',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      for (final item in widget.store.notifications) ...[
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.title),
                          subtitle: Text('${item.target} • ${item.schedule}'),
                          trailing: StatusChip(
                            label: item.status,
                            color: item.status == 'Delivered'
                                ? BrandColors.success
                                : BrandColors.warning,
                          ),
                        ),
                        if (item != widget.store.notifications.last)
                          const Divider(color: BrandColors.border),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendNotification() {
    final targetLabel = switch (_target) {
      NotificationTarget.allStudents => 'All Students',
      NotificationTarget.course => _courseTarget ?? 'Course',
      NotificationTarget.individual => _studentTarget ?? 'Student',
    };

    widget.store.sendNotification(
      NotificationItem(
        id: 'notification_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        target: targetLabel,
        schedule: _scheduled && _scheduledAt != null
            ? '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year}'
            : 'Sent instantly',
        status: _scheduled ? 'Scheduled' : 'Delivered',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _scheduled ? 'Notification scheduled in static mode.' : 'Notification sent in static mode.',
        ),
      ),
    );
    _titleController.clear();
    _messageController.clear();
    setState(() => _scheduled = false);
  }
}
