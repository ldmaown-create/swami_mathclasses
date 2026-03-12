import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class CoursesFeature extends StatefulWidget {
  const CoursesFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  State<CoursesFeature> createState() => _CoursesFeatureState();
}

class _CoursesFeatureState extends State<CoursesFeature> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase();
    final courses = widget.store.courses.where((course) {
      return course.name.toLowerCase().contains(query) ||
          course.board.toLowerCase().contains(query);
    }).toList();

    return AdminPageContainer(
      child: ListView(
        children: [
          SectionHeader(
            title: 'Course Management',
            subtitle: 'Create, edit, activate, and manage batch-end dates for all courses.',
            action: AccentButton(
              label: 'Create Course',
              icon: Icons.add,
              onPressed: () => _openCourseForm(context),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilterTextField(
                  controller: _searchController,
                  hintText: 'Search by course or board',
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.tune),
                label: const Text('Refresh'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (courses.isEmpty)
            EmptyStateCard(
              title: 'No courses matched the current filter',
              message: 'Clear the search query or create a new course to continue.',
              action: AccentButton(
                label: 'Clear Search',
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            )
          else
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 28,
                  columns: const [
                    DataColumn(label: Text('Course')),
                    DataColumn(label: Text('Board')),
                    DataColumn(label: Text('Standard')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Batch End')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: courses.map((course) {
                    return DataRow(
                      cells: [
                        DataCell(Text(course.name)),
                        DataCell(Text(course.board)),
                        DataCell(Text(course.standard)),
                        DataCell(Text('Rs. ${course.price}')),
                        DataCell(Text(_formatDate(course.batchEndDate))),
                        DataCell(
                          StatusChip(
                            label: course.isActive ? 'Active' : 'Inactive',
                            color: course.isActive
                                ? BrandColors.success
                                : BrandColors.warning,
                          ),
                        ),
                        DataCell(
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: () => _openCourseForm(context, course: course),
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () => _confirmToggle(context, course),
                                child: Text(course.isActive ? 'Deactivate' : 'Activate'),
                              ),
                              TextButton(
                                onPressed: () => _confirmBatchChange(context, course),
                                child: const Text('Batch Date'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openCourseForm(BuildContext context, {Course? course}) async {
    final nameController = TextEditingController(text: course?.name ?? '');
    final boardController = TextEditingController(text: course?.board ?? '');
    final standardController = TextEditingController(text: course?.standard ?? '');
    final priceController = TextEditingController(
      text: course?.price.toString() ?? '12499',
    );
    final descriptionController = TextEditingController(
      text: course?.description ?? '',
    );

    String folderStructure = course?.folderStructure ?? 'Dual Folder';
    DateTime batchDate = course?.batchEndDate ?? DateTime(2027, 3, 31);
    bool isActive = course?.isActive ?? true;

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
                  course == null ? 'Create Course' : 'Edit Course',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 20),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: boardController,
                        decoration: const InputDecoration(labelText: 'Board'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: standardController,
                        decoration: const InputDecoration(labelText: 'Class'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: folderStructure,
                        decoration: const InputDecoration(labelText: 'Folder Structure'),
                        items: const [
                          DropdownMenuItem(value: 'Dual Folder', child: Text('Dual Folder')),
                          DropdownMenuItem(value: 'Single Folder', child: Text('Single Folder')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() => folderStructure = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Batch End: ${_formatDate(batchDate)}'),
                  trailing: TextButton(
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: batchDate,
                        firstDate: DateTime(2026),
                        lastDate: DateTime(2030),
                      );
                      if (selected != null) {
                        setDialogState(() => batchDate = selected);
                      }
                    },
                    child: const Text('Change'),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isActive,
                  title: const Text('Active at launch'),
                  onChanged: (value) => setDialogState(() => isActive = value),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    AccentButton(
                      label: course == null ? 'Create Course' : 'Save Changes',
                      onPressed: () {
                        final nextCourse = Course(
                          id: course?.id ?? 'course_${DateTime.now().millisecondsSinceEpoch}',
                          name: nameController.text.trim(),
                          board: boardController.text.trim(),
                          standard: standardController.text.trim(),
                          price: int.tryParse(priceController.text.trim()) ?? 0,
                          batchEndDate: batchDate,
                          isActive: isActive,
                          folderStructure: folderStructure,
                          description: descriptionController.text.trim(),
                        );
                        if (course == null) {
                          widget.store.createCourse(nextCourse);
                        } else {
                          widget.store.updateCourse(nextCourse);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmToggle(BuildContext context, Course course) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.isActive ? 'Deactivate Course' : 'Activate Course',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              course.isActive
                  ? 'This removes the course from student visibility immediately.'
                  : 'This makes the course available to operational flows immediately.',
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                AccentButton(
                  label: course.isActive ? 'Deactivate' : 'Activate',
                  onPressed: () {
                    widget.store.toggleCourse(course.id);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmBatchChange(BuildContext context, Course course) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Batch End Date Change',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              'Per flow requirements, changing the batch end date must apply immediately to all existing subscriptions and log an audit event.',
            ),
            const SizedBox(height: 10),
            Text(
              'Current course: ${course.name}\nCurrent date: ${_formatDate(course.batchEndDate)}',
              style: const TextStyle(color: BrandColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: 'Edit Course',
                onPressed: () {
                  Navigator.of(context).pop();
                  _openCourseForm(context, course: course);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime value) {
    return '${value.day}/${value.month}/${value.year}';
  }
}
