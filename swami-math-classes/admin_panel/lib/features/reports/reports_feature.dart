import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class ReportsFeature extends StatefulWidget {
  const ReportsFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  State<ReportsFeature> createState() => _ReportsFeatureState();
}

class _ReportsFeatureState extends State<ReportsFeature> {
  ReportType _reportType = ReportType.revenue;
  ExportFormat _exportFormat = ExportFormat.csv;
  DateTimeRange? _range;
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    return AdminPageContainer(
      child: ListView(
        children: [
          SectionHeader(
            title: 'Reports & Export',
            subtitle: 'Review aggregated admin reports and export them as static files for workflow validation.',
            action: AccentButton(
              label: 'Export Report',
              icon: Icons.file_download_outlined,
              onPressed: _exporting ? null : () => _startExport(context),
            ),
          ),
          const SizedBox(height: 24),
          SurfaceCard(
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ReportType>(
                    value: _reportType,
                    decoration: const InputDecoration(labelText: 'Report Type'),
                    items: const [
                      DropdownMenuItem(value: ReportType.revenue, child: Text('Revenue')),
                      DropdownMenuItem(value: ReportType.subscriptions, child: Text('Subscriptions')),
                      DropdownMenuItem(value: ReportType.students, child: Text('Students')),
                      DropdownMenuItem(value: ReportType.offlineAssignments, child: Text('Offline Assignments')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _reportType = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ExportFormat>(
                    value: _exportFormat,
                    decoration: const InputDecoration(labelText: 'Export Format'),
                    items: const [
                      DropdownMenuItem(value: ExportFormat.csv, child: Text('CSV')),
                      DropdownMenuItem(value: ExportFormat.excel, child: Text('Excel')),
                      DropdownMenuItem(value: ExportFormat.pdf, child: Text('PDF')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _exportFormat = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () async {
                    final selected = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                    );
                    if (selected != null) {
                      setState(() => _range = selected);
                    }
                  },
                  child: Text(_range == null
                      ? 'Select Date Range'
                      : '${_range!.start.day}/${_range!.start.month} - ${_range!.end.day}/${_range!.end.month}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: widget.store.reports.length,
            itemBuilder: (context, index) {
              final report = widget.store.reports[index];
              return SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.label, style: const TextStyle(color: BrandColors.textSecondary)),
                    const SizedBox(height: 12),
                    Text(
                      report.amount,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(report.count),
                  ],
                ),
              );
            },
          ),
          if (_exporting) ...[
            const SizedBox(height: 24),
            const SurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Export in progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  SizedBox(height: 14),
                  LinearProgressIndicator(color: BrandColors.accent),
                  SizedBox(height: 12),
                  Text('Generating static download package for selected report and format.'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startExport(BuildContext context) async {
    setState(() => _exporting = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) {
      return;
    }
    setState(() => _exporting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Static export ready: ${_reportType.name}.${_exportFormat.name}',
        ),
      ),
    );
  }
}
