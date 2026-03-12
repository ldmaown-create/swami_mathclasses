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
    return AdminPageContainer(
      child: ListView(
        children: [
          const SectionHeader(
            title: 'Operations Dashboard',
            subtitle: 'Track subscriptions, revenue, enrollments, and recent admin activity.',
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.65,
            ),
            itemCount: store.metrics.length,
            itemBuilder: (context, index) {
              final metric = store.metrics[index];
              return DashboardMetricCard(
                label: metric.label,
                value: metric.value,
                delta: metric.delta,
                positive: metric.positive,
              );
            },
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
                        'Revenue Trend',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 18),
                      const _MiniBarChart(),
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
                        'Recent Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
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
      ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    final bars = <double>[72, 64, 91, 80, 106, 94, 118];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in bars) ...[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: value,
                  decoration: BoxDecoration(
                    color: BrandColors.accent.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'W',
                  style: TextStyle(color: BrandColors.textSecondary),
                ),
              ],
            ),
          ),
          if (value != bars.last) const SizedBox(width: 12),
        ],
      ],
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: BrandColors.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            timestamp,
            style: const TextStyle(color: BrandColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
