import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class StudentsFeature extends StatefulWidget {
  const StudentsFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  State<StudentsFeature> createState() => _StudentsFeatureState();
}

class _StudentsFeatureState extends State<StudentsFeature> {
  final TextEditingController _searchController = TextEditingController();
  StudentStatus? _statusFilter;
  StudentRecord? _selectedStudent;

  @override
  void initState() {
    super.initState();
    _selectedStudent = widget.store.students.isEmpty ? null : widget.store.students.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final students = widget.store.students.where((student) {
      final matchesQuery = student.name.toLowerCase().contains(query) ||
          student.mobile.contains(query) ||
          student.courseName.toLowerCase().contains(query);
      final matchesStatus = _statusFilter == null || student.status == _statusFilter;
      return matchesQuery && matchesStatus;
    }).toList();

    final detail = _selectedStudent ?? (students.isEmpty ? null : students.first);

    return AdminPageContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ListView(
              children: [
                const SectionHeader(
                  title: 'Student Management',
                  subtitle: 'Search, inspect, pause, reset devices, and assign offline subscriptions.',
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: FilterTextField(
                        controller: _searchController,
                        hintText: 'Search by student, mobile, or course',
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<StudentStatus?>(
                      value: _statusFilter,
                      dropdownColor: BrandColors.surface,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('All Statuses')),
                        DropdownMenuItem(value: StudentStatus.active, child: Text('Active')),
                        DropdownMenuItem(value: StudentStatus.paused, child: Text('Paused')),
                      ],
                      onChanged: (value) => setState(() => _statusFilter = value),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SurfaceCard(
                  padding: EdgeInsets.zero,
                  child: students.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: EmptyStateCard(
                            title: 'No students found',
                            message: 'Adjust filters or wait for subscription data to be integrated.',
                          ),
                        )
                      : Column(
                          children: [
                            for (final student in students) ...[
                              InkWell(
                                onTap: () => setState(() => _selectedStudent = student),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: BrandColors.accent.withOpacity(0.18),
                                        child: Text(
                                          student.name.characters.first,
                                          style: const TextStyle(
                                            color: BrandColors.accent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(student.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${student.mobile} • ${student.courseName}',
                                              style: const TextStyle(color: BrandColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                      StatusChip(
                                        label: student.status == StudentStatus.active ? 'Active' : 'Paused',
                                        color: student.status == StudentStatus.active
                                            ? BrandColors.success
                                            : BrandColors.warning,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (student != students.last) const Divider(color: BrandColors.border),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: detail == null
                ? const EmptyStateCard(
                    title: 'No student selected',
                    message: 'Select a row from the student list to inspect detail and actions.',
                  )
                : SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(detail.mobile, style: const TextStyle(color: BrandColors.textSecondary)),
                        const SizedBox(height: 18),
                        _InfoRow(label: 'Course', value: detail.courseName),
                        _InfoRow(label: 'Device ID', value: detail.deviceId),
                        _InfoRow(label: 'Payment Mode', value: detail.paymentMode),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            AccentButton(
                              label: detail.status == StudentStatus.active ? 'Pause Account' : 'Resume Account',
                              onPressed: () => _confirmToggleStatus(context, detail),
                            ),
                            OutlinedButton(
                              onPressed: () => _confirmResetDevice(context, detail),
                              child: const Text('Reset Device'),
                            ),
                            OutlinedButton(
                              onPressed: () => _assignOfflineCourse(context, detail),
                              child: const Text('Assign Course'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmToggleStatus(BuildContext context, StudentRecord student) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.status == StudentStatus.active ? 'Pause Account' : 'Resume Account',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text('This change applies immediately to secure video access for ${student.name}.'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: student.status == StudentStatus.active ? 'Pause Now' : 'Resume Now',
                onPressed: () {
                  widget.store.toggleStudentStatus(student.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmResetDevice(BuildContext context, StudentRecord student) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Device',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text('This clears the current device binding and forces OTP re-login for ${student.name}.'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: 'Reset Device',
                onPressed: () {
                  widget.store.resetDevice(student.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _assignOfflineCourse(BuildContext context, StudentRecord student) async {
    String courseName = widget.store.courses.first.name;
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Course Assignment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                Text('Assign a course directly without online payment for ${student.name}.'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: courseName,
                  decoration: const InputDecoration(labelText: 'Course'),
                  items: widget.store.courses
                      .map(
                        (course) => DropdownMenuItem(
                          value: course.name,
                          child: Text(course.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() => courseName = value);
                  },
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: AccentButton(
                    label: 'Assign Offline',
                    onPressed: () {
                      widget.store.assignOfflineCourse(studentId: student.id, courseName: courseName);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: BrandColors.textSecondary)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
