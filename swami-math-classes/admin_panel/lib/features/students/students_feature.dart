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
  String? _paymentFilter;
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
      final matchesPayment = _paymentFilter == null || student.paymentMode == _paymentFilter;
      return matchesQuery && matchesStatus && matchesPayment;
    }).toList();

    final detail = students.any((student) => student.id == _selectedStudent?.id)
        ? students.firstWhere((student) => student.id == _selectedStudent?.id)
        : (students.isEmpty ? null : students.first);
    final activeCount =
        widget.store.students.where((student) => student.status == StudentStatus.active).length;
    final pausedCount =
        widget.store.students.where((student) => student.status == StudentStatus.paused).length;
    final offlineCount =
        widget.store.students.where((student) => student.paymentMode == 'Offline').length;

    return AdminPageContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final splitLayout = constraints.maxWidth > 1260;

          return ListView(
            children: [
              const SectionHeader(
                title: 'Student Management',
                subtitle:
                    'Search, inspect, pause, reset devices, and assign offline subscriptions.',
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StudentSummaryCard(
                    label: 'Total Students',
                    value: widget.store.students.length.toString(),
                    icon: Icons.people_alt_outlined,
                  ),
                  _StudentSummaryCard(
                    label: 'Active',
                    value: activeCount.toString(),
                    icon: Icons.verified_user_outlined,
                    color: BrandColors.success,
                  ),
                  _StudentSummaryCard(
                    label: 'Paused',
                    value: pausedCount.toString(),
                    icon: Icons.pause_circle_outline,
                    color: BrandColors.warning,
                  ),
                  _StudentSummaryCard(
                    label: 'Offline Assignments',
                    value: offlineCount.toString(),
                    icon: Icons.assignment_ind_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SurfaceCard(
                child: Column(
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: splitLayout ? 360 : double.infinity,
                          child: FilterTextField(
                            controller: _searchController,
                            hintText: 'Search by student, mobile, or course',
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: DropdownButtonFormField<StudentStatus?>(
                            value: _statusFilter,
                            decoration: const InputDecoration(labelText: 'Status'),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('All Statuses')),
                              DropdownMenuItem(
                                value: StudentStatus.active,
                                child: Text('Active'),
                              ),
                              DropdownMenuItem(
                                value: StudentStatus.paused,
                                child: Text('Paused'),
                              ),
                            ],
                            onChanged: (value) => setState(() => _statusFilter = value),
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: DropdownButtonFormField<String?>(
                            value: _paymentFilter,
                            decoration: const InputDecoration(labelText: 'Payment Mode'),
                            items: const [
                              DropdownMenuItem(value: null, child: Text('All Payments')),
                              DropdownMenuItem(value: 'Razorpay', child: Text('Razorpay')),
                              DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                            ],
                            onChanged: (value) => setState(() => _paymentFilter = value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (splitLayout)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildListPanel(students)),
                          const SizedBox(width: 16),
                          Expanded(flex: 2, child: _buildDetailPanel(context, detail)),
                        ],
                      )
                    else ...[
                      _buildListPanel(students),
                      const SizedBox(height: 16),
                      _buildDetailPanel(context, detail),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListPanel(List<StudentRecord> students) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BrandColors.border),
      ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Student',
                          style: TextStyle(
                            color: BrandColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Text(
                          'Course',
                          style: TextStyle(
                            color: BrandColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Status',
                        style: TextStyle(
                          color: BrandColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: BrandColors.border, height: 1),
                for (final student in students) ...[
                  _StudentRow(
                    student: student,
                    selected: student.id == _selectedStudent?.id,
                    onTap: () => setState(() => _selectedStudent = student),
                  ),
                  if (student != students.last)
                    const Divider(color: BrandColors.border, height: 1),
                ],
              ],
            ),
    );
  }

  Widget _buildDetailPanel(BuildContext context, StudentRecord? detail) {
    if (detail == null) {
      return const EmptyStateCard(
        title: 'No student selected',
        message: 'Select a row from the student list to inspect detail and actions.',
      );
    }

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: BrandColors.accent.withOpacity(0.18),
                child: Text(
                  detail.name.characters.first,
                  style: const TextStyle(
                    color: BrandColors.accent,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      detail.mobile,
                      style: const TextStyle(color: BrandColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              StatusChip(
                label: detail.status == StudentStatus.active ? 'Active' : 'Paused',
                color: detail.status == StudentStatus.active
                    ? BrandColors.success
                    : BrandColors.warning,
              ),
              const SizedBox(width: 8),
              StatusChip(
                label: detail.paymentMode,
                color: detail.paymentMode == 'Offline'
                    ? BrandColors.accent
                    : BrandColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(label: 'Course', value: detail.courseName),
          _InfoRow(label: 'Device ID', value: detail.deviceId),
          _InfoRow(label: 'Payment Mode', value: detail.paymentMode),
          const SizedBox(height: 20),
          const Text(
            'Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AccentButton(
              label: detail.status == StudentStatus.active
                  ? 'Pause Account'
                  : 'Resume Account',
              onPressed: () => _confirmToggleStatus(context, detail),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _confirmResetDevice(context, detail),
              child: const Text('Reset Device'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _assignOfflineCourse(context, detail),
              child: const Text('Assign Course'),
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'This change applies immediately to secure video access for ${student.name}.',
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: student.status == StudentStatus.active ? 'Pause Now' : 'Resume Now',
                onPressed: () {
                  widget.store.toggleStudentStatus(student.id);
                  Navigator.of(context).pop();
                  setState(() {});
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'This clears the current device binding and forces OTP re-login for ${student.name}.',
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: 'Reset Device',
                onPressed: () {
                  widget.store.resetDevice(student.id);
                  Navigator.of(context).pop();
                  setState(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _assignOfflineCourse(BuildContext context, StudentRecord student) async {
    if (widget.store.courses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create a course before assigning an offline subscription.'),
        ),
      );
      return;
    }

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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
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
                      widget.store.assignOfflineCourse(
                        studentId: student.id,
                        courseName: courseName,
                      );
                      Navigator.of(context).pop();
                      setState(() {});
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

class _StudentSummaryCard extends StatelessWidget {
  const _StudentSummaryCard({
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

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.selected,
    required this.onTap,
  });

  final StudentRecord student;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? BrandColors.accent.withOpacity(0.08) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.mobile,
                      style: const TextStyle(color: BrandColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Text(
                  student.courseName,
                  style: const TextStyle(color: BrandColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
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
