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
  String _timeSlot = '08:00 AM';

  @override
  void initState() {
    super.initState();
    _courseTarget = widget.store.courses.isEmpty ? null : widget.store.courses.first.name;
    _studentTarget = widget.store.students.isEmpty ? null : widget.store.students.first.name;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveredCount =
        widget.store.notifications.where((item) => item.status == 'Delivered').length;
    final scheduledCount =
        widget.store.notifications.where((item) => item.status == 'Scheduled').length;

    return AdminPageContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final splitLayout = constraints.maxWidth > 1280;

          return ListView(
            children: [
              const SectionHeader(
                title: 'Notification Management',
                subtitle:
                    'Compose announcements, target recipients, and schedule delivery with static preview states.',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _NotificationSummaryCard(
                    label: 'Total Messages',
                    value: widget.store.notifications.length.toString(),
                    icon: Icons.campaign_outlined,
                  ),
                  _NotificationSummaryCard(
                    label: 'Delivered',
                    value: deliveredCount.toString(),
                    icon: Icons.done_all_outlined,
                    color: BrandColors.success,
                  ),
                  _NotificationSummaryCard(
                    label: 'Scheduled',
                    value: scheduledCount.toString(),
                    icon: Icons.schedule_outlined,
                    color: BrandColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (splitLayout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildComposer(context)),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildPreviewPanel(context),
                          const SizedBox(height: 16),
                          _buildHistoryPanel(context),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                _buildComposer(context),
                const SizedBox(height: 16),
                _buildPreviewPanel(context),
                const SizedBox(height: 16),
                _buildHistoryPanel(context),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compose Message',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Send to all students, a course cohort, or one individual learner.',
            style: TextStyle(color: BrandColors.textSecondary),
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
              ButtonSegment(
                value: NotificationTarget.allStudents,
                label: Text('All Students'),
              ),
              ButtonSegment(
                value: NotificationTarget.course,
                label: Text('Specific Course'),
              ),
              ButtonSegment(
                value: NotificationTarget.individual,
                label: Text('Individual'),
              ),
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
          if (_target != NotificationTarget.allStudents) const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _scheduled,
            title: const Text('Schedule delivery'),
            subtitle: const Text(
              'Required for future campaign planning and reminder pushes.',
              style: TextStyle(color: BrandColors.textSecondary),
            ),
            onChanged: (value) => setState(() => _scheduled = value),
          ),
          if (_scheduled) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
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
                    child: Text(
                      _scheduledAt == null
                          ? 'Pick Date'
                          : '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _timeSlot,
                    decoration: const InputDecoration(labelText: 'Time Slot'),
                    items: const [
                      DropdownMenuItem(value: '08:00 AM', child: Text('08:00 AM')),
                      DropdownMenuItem(value: '12:00 PM', child: Text('12:00 PM')),
                      DropdownMenuItem(value: '06:00 PM', child: Text('06:00 PM')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _timeSlot = value);
                    },
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: AccentButton(
              label: _scheduled ? 'Schedule Notification' : 'Send Notification',
              icon: _scheduled ? Icons.schedule_send_outlined : Icons.send_outlined,
              onPressed: _sendNotification,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewPanel(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Preview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Static delivery preview for the selected targeting mode.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          _PreviewRow(label: 'Audience', value: _targetLabel()),
          _PreviewRow(
            label: 'Delivery',
            value: _scheduled
                ? _scheduledAt == null
                    ? 'Schedule not selected'
                    : '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year} at $_timeSlot'
                : 'Sent instantly',
          ),
          _PreviewRow(
            label: 'Title',
            value: _titleController.text.trim().isEmpty
                ? 'No title entered'
                : _titleController.text.trim(),
          ),
          _PreviewRow(
            label: 'Message',
            value: _messageController.text.trim().isEmpty
                ? 'No message entered'
                : _messageController.text.trim(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryPanel(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Delivered and scheduled announcements for operations review.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 16),
          for (final item in widget.store.notifications) ...[
            _HistoryTile(item: item),
            if (item != widget.store.notifications.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  String _targetLabel() {
    return switch (_target) {
      NotificationTarget.allStudents => 'All Students',
      NotificationTarget.course => _courseTarget ?? 'Course not selected',
      NotificationTarget.individual => _studentTarget ?? 'Student not selected',
    };
  }

  void _sendNotification() {
    final targetLabel = _targetLabel();

    widget.store.sendNotification(
      NotificationItem(
        id: 'notification_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim().isEmpty
            ? 'Untitled Notification'
            : _titleController.text.trim(),
        message: _messageController.text.trim().isEmpty
            ? 'No message entered.'
            : _messageController.text.trim(),
        target: targetLabel,
        schedule: _scheduled && _scheduledAt != null
            ? '${_scheduledAt!.day}/${_scheduledAt!.month}/${_scheduledAt!.year} $_timeSlot'
            : 'Sent instantly',
        status: _scheduled ? 'Scheduled' : 'Delivered',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _scheduled
              ? 'Notification scheduled in static mode.'
              : 'Notification sent in static mode.',
        ),
      ),
    );

    _titleController.clear();
    _messageController.clear();
    setState(() {
      _scheduled = false;
      _scheduledAt = null;
      _timeSlot = '08:00 AM';
    });
  }
}

class _NotificationSummaryCard extends StatelessWidget {
  const _NotificationSummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color = BrandColors.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: SurfaceCard(
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: const TextStyle(color: BrandColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: const TextStyle(color: BrandColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              StatusChip(
                label: item.status,
                color: item.status == 'Delivered'
                    ? BrandColors.success
                    : BrandColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.message,
            style: const TextStyle(color: BrandColors.textSecondary),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            '${item.target}  •  ${item.schedule}',
            style: const TextStyle(
              color: BrandColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
