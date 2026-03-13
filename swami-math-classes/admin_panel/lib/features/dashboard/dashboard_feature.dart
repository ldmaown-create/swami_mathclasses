import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/widgets/admin_components.dart';

class DashboardFeature extends StatelessWidget {
  const DashboardFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  Widget build(BuildContext context) {
    final enrollmentData = _buildEnrollmentData();
    final activeStudents =
        store.students.where((student) => student.status.name == 'active').length;
    final offlineStudents =
        store.students.where((student) => student.paymentMode == 'Offline').length;

    return AdminPageContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metricColumns = constraints.maxWidth > 1500
              ? 4
              : constraints.maxWidth > 1100
                  ? 2
                  : 1;
          final metricAspectRatio = constraints.maxWidth > 1500
              ? 2.25
              : constraints.maxWidth > 1100
                  ? 2.0
                  : 2.45;
          final splitPanels = constraints.maxWidth > 1320;

          return ListView(
            children: [
              SectionHeader(
                title: 'Operations Dashboard',
                subtitle:
                    'Track subscriptions, revenue, enrollments, and recent admin activity.',
                action: const AccentButton(
                  label: 'Export Snapshot',
                  icon: Icons.download_outlined,
                ),
              ),
              const SizedBox(height: 20),
              _OverviewStrip(
                activeStudents: activeStudents,
                totalCourses: store.courses.length,
                offlineStudents: offlineStudents,
                queuedVideos: store.videos.where((video) => !video.published).length,
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: metricColumns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: metricAspectRatio,
                ),
                itemCount: store.metrics.length,
                itemBuilder: (context, index) {
                  final metric = store.metrics[index];
                  return DashboardMetricCard(
                    label: metric.label,
                    value: metric.value,
                    delta: metric.delta,
                    positive: metric.positive,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${metric.label} drill-down is static in this phase.'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              const _QuickActionSection(),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: splitPanels
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth,
                    child: const _RevenueTrendCard(),
                  ),
                  SizedBox(
                    width: splitPanels
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth,
                    child: _CourseEnrollmentCard(items: enrollmentData),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: splitPanels
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth,
                    child: _OperationsWatchCard(
                      activeStudents: activeStudents,
                      offlineStudents: offlineStudents,
                      pendingVideos:
                          store.videos.where((video) => !video.published).length,
                    ),
                  ),
                  SizedBox(
                    width: splitPanels
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth,
                    child: SurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Activity',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Last payments, uploads, and admin actions.',
                            style: TextStyle(color: BrandColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          for (final item in store.activities) ...[
                            _ActivityTile(
                              title: item.title,
                              subtitle: item.subtitle,
                              timestamp: item.timestamp,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  List<_EnrollmentDatum> _buildEnrollmentData() {
    return store.courses.map((course) {
      final count = store.students
          .where((student) => student.courseName == course.name)
          .length;
      return _EnrollmentDatum(
        label: course.standard,
        title: course.name,
        value: count,
        active: course.isActive,
      );
    }).toList()
      ..sort((left, right) => right.value.compareTo(left.value));
  }
}

class _OverviewStrip extends StatelessWidget {
  const _OverviewStrip({
    required this.activeStudents,
    required this.totalCourses,
    required this.offlineStudents,
    required this.queuedVideos,
  });

  final int activeStudents;
  final int totalCourses;
  final int offlineStudents;
  final int queuedVideos;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Wrap(
        spacing: 24,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _OverviewItem(
            label: 'Active students',
            value: activeStudents.toString(),
            icon: Icons.people_alt_outlined,
          ),
          _OverviewItem(
            label: 'Live courses',
            value: totalCourses.toString(),
            icon: Icons.menu_book_outlined,
          ),
          _OverviewItem(
            label: 'Offline assignments',
            value: offlineStudents.toString(),
            icon: Icons.assignment_ind_outlined,
          ),
          _OverviewItem(
            label: 'Video queue',
            value: queuedVideos.toString(),
            icon: Icons.cloud_upload_outlined,
          ),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  const _OverviewItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: BrandColors.accent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BrandColors.border),
          ),
          child: Icon(icon, color: BrandColors.accent),
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(color: BrandColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionSection extends StatelessWidget {
  const _QuickActionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Most-used operational actions surfaced directly on the dashboard.',
          style: TextStyle(color: BrandColors.textSecondary),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: const [
            _QuickActionCard(
              title: 'Create Course',
              subtitle: 'Add a new course shell and pricing structure.',
              icon: Icons.add_box_outlined,
            ),
            _QuickActionCard(
              title: 'Upload Lecture',
              subtitle: 'Start a new lecture upload and publish flow.',
              icon: Icons.video_call_outlined,
            ),
            _QuickActionCard(
              title: 'Assign Offline Student',
              subtitle: 'Activate subscription directly without online payment.',
              icon: Icons.assignment_ind_outlined,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: BrandColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: BrandColors.accent),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(color: BrandColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueTrendCard extends StatelessWidget {
  const _RevenueTrendCard();

  @override
  Widget build(BuildContext context) {
    final bars = <double>[72, 64, 91, 80, 106, 94, 118];
    final months = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Trend',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Monthly collection trend for current academic cycle.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < bars.length; index++) ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: bars[index],
                          decoration: BoxDecoration(
                            color: BrandColors.accent.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          months[index],
                          style: const TextStyle(color: BrandColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (index != bars.length - 1) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseEnrollmentCard extends StatelessWidget {
  const _CourseEnrollmentCard({required this.items});

  final List<_EnrollmentDatum> items;

  @override
  Widget build(BuildContext context) {
    final maxValue = items.isEmpty
        ? 1
        : items.map((item) => item.value).reduce((left, right) => left > right ? left : right);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course-wise Enrollments',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Current student distribution across configured courses.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          for (final item in items) ...[
            _EnrollmentBar(item: item, maxValue: maxValue),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _EnrollmentBar extends StatelessWidget {
  const _EnrollmentBar({
    required this.item,
    required this.maxValue,
  });

  final _EnrollmentDatum item;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    final widthFactor = maxValue == 0 ? 0.0 : item.value / maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: StatusChip(
                label: item.active ? 'Active' : 'Inactive',
                color: item.active ? BrandColors.success : BrandColors.warning,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${item.value}',
              style: const TextStyle(
                color: BrandColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: widthFactor.clamp(0.0, 1.0),
            minHeight: 12,
            backgroundColor: Colors.black,
            color: BrandColors.accent,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          item.label,
          style: const TextStyle(
            color: BrandColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _OperationsWatchCard extends StatelessWidget {
  const _OperationsWatchCard({
    required this.activeStudents,
    required this.offlineStudents,
    required this.pendingVideos,
  });

  final int activeStudents;
  final int offlineStudents;
  final int pendingVideos;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operations Watchlist',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Immediate operational checks surfaced for admin review.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          _WatchItem(
            title: 'Offline assignments require reconciliation',
            subtitle:
                '$offlineStudents students are currently tagged with offline payment mode.',
            color: BrandColors.warning,
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 12),
          _WatchItem(
            title: 'Publishing queue',
            subtitle: '$pendingVideos lecture uploads are still pending publication.',
            color: BrandColors.accent,
            icon: Icons.cloud_upload_outlined,
          ),
          const SizedBox(height: 12),
          _WatchItem(
            title: 'Active subscription base',
            subtitle:
                '$activeStudents students are active. Review churn trend against daily additions.',
            color: BrandColors.success,
            icon: Icons.trending_up_outlined,
          ),
        ],
      ),
    );
  }
}

class _WatchItem extends StatelessWidget {
  const _WatchItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
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
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: BrandColors.textSecondary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String title;
  final String subtitle;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BrandColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Color(0x22F4B400),
            child: Icon(Icons.bolt_outlined, color: BrandColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: BrandColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  timestamp,
                  style: const TextStyle(
                    color: BrandColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EnrollmentDatum {
  const _EnrollmentDatum({
    required this.label,
    required this.title,
    required this.value,
    required this.active,
  });

  final String label;
  final String title;
  final int value;
  final bool active;
}
