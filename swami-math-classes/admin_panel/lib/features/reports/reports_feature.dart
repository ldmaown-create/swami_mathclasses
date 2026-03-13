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
  String? _lastExportLabel;

  @override
  Widget build(BuildContext context) {
    final cards = _reportCardsForType();

    return AdminPageContainer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final metricColumns = constraints.maxWidth > 1500
              ? 4
              : constraints.maxWidth > 1050
                  ? 2
                  : 1;
          final splitLayout = constraints.maxWidth > 1280;

          return ListView(
            children: [
              SectionHeader(
                title: 'Reports & Export',
                subtitle:
                    'Review aggregated admin reports and export them as static files for workflow validation.',
                action: AccentButton(
                  label: _exporting ? 'Exporting...' : 'Export Report',
                  icon: Icons.file_download_outlined,
                  onPressed: _exporting ? null : () => _startExport(context),
                ),
              ),
              const SizedBox(height: 20),
              SurfaceCard(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<ReportType>(
                        value: _reportType,
                        decoration: const InputDecoration(labelText: 'Report Type'),
                        items: const [
                          DropdownMenuItem(
                            value: ReportType.revenue,
                            child: Text('Revenue'),
                          ),
                          DropdownMenuItem(
                            value: ReportType.subscriptions,
                            child: Text('Subscriptions'),
                          ),
                          DropdownMenuItem(
                            value: ReportType.students,
                            child: Text('Students'),
                          ),
                          DropdownMenuItem(
                            value: ReportType.offlineAssignments,
                            child: Text('Offline Assignments'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _reportType = value);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
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
                      child: Text(
                        _range == null
                            ? 'Select Date Range'
                            : '${_range!.start.day}/${_range!.start.month}/${_range!.start.year} - ${_range!.end.day}/${_range!.end.month}/${_range!.end.year}',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: metricColumns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.2,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final report = cards[index];
                  return SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          report.label,
                          style: const TextStyle(color: BrandColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          report.amount,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          report.count,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              if (splitLayout)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildReportInsightPanel(context, cards),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildExportPanel(context),
                    ),
                  ],
                )
              else ...[
                _buildReportInsightPanel(context, cards),
                const SizedBox(height: 16),
                _buildExportPanel(context),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildReportInsightPanel(BuildContext context, List<ReportItem> cards) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_reportTypeLabel()} Snapshot',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _range == null
                ? 'No date range selected. Export will use the default static reporting window.'
                : 'Reporting window: ${_range!.start.day}/${_range!.start.month}/${_range!.start.year} to ${_range!.end.day}/${_range!.end.month}/${_range!.end.year}',
            style: const TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          for (final card in cards) ...[
            _ReportInsightRow(item: card),
            if (card != cards.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildExportPanel(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Export Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'CSV, Excel, and PDF exports are simulated for UI validation in this phase.',
            style: TextStyle(color: BrandColors.textSecondary),
          ),
          const SizedBox(height: 18),
          _ExportMetaRow(label: 'Report', value: _reportTypeLabel()),
          _ExportMetaRow(label: 'Format', value: _exportFormat.name.toUpperCase()),
          _ExportMetaRow(
            label: 'Window',
            value: _range == null ? 'Default' : 'Custom date range selected',
          ),
          const SizedBox(height: 18),
          if (_exporting) ...[
            const LinearProgressIndicator(color: BrandColors.accent),
            const SizedBox(height: 12),
            const Text('Generating static export package...'),
          ] else if (_lastExportLabel != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: BrandColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrandColors.success.withOpacity(0.3)),
              ),
              child: Text(
                'Ready: $_lastExportLabel',
                style: const TextStyle(
                  color: BrandColors.success,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrandColors.border),
              ),
              child: const Text(
                'No export generated yet.',
                style: TextStyle(color: BrandColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _reportTypeLabel() {
    return switch (_reportType) {
      ReportType.revenue => 'Revenue',
      ReportType.subscriptions => 'Subscriptions',
      ReportType.students => 'Students',
      ReportType.offlineAssignments => 'Offline Assignments',
    };
  }

  List<ReportItem> _reportCardsForType() {
    final items = widget.store.reports;

    return switch (_reportType) {
      ReportType.revenue => items.where((item) => item.id == 'rep_1').toList(),
      ReportType.subscriptions => items.where((item) => item.id == 'rep_2').toList(),
      ReportType.students => items.where((item) => item.id == 'rep_3').toList(),
      ReportType.offlineAssignments => items.where((item) => item.id == 'rep_4').toList(),
    };
  }

  Future<void> _startExport(BuildContext context) async {
    setState(() => _exporting = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) {
      return;
    }

    final label =
        '${_reportTypeLabel().toLowerCase().replaceAll(' ', '_')}.${_exportFormat.name}';

    setState(() {
      _exporting = false;
      _lastExportLabel = label;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Static export ready: $label'),
      ),
    );
  }
}

class _ReportInsightRow extends StatelessWidget {
  const _ReportInsightRow({required this.item});

  final ReportItem item;

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
          Text(
            item.label,
            style: const TextStyle(
              color: BrandColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.amount,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            item.count,
            style: const TextStyle(color: BrandColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ExportMetaRow extends StatelessWidget {
  const _ExportMetaRow({
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
            width: 72,
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
