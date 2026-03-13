import 'package:flutter/material.dart';

import '../../core/data/admin_mock_store.dart';
import '../../core/models/admin_models.dart';
import '../../core/widgets/admin_components.dart';

class VideosFeature extends StatefulWidget {
  const VideosFeature({
    required this.store,
    super.key,
  });

  final AdminMockStore store;

  @override
  State<VideosFeature> createState() => _VideosFeatureState();
}

class _VideosFeatureState extends State<VideosFeature> {
  String? _selectedCourseId;

  @override
  void initState() {
    super.initState();
    if (widget.store.courses.isNotEmpty) {
      _selectedCourseId = widget.store.courses.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store.courses.isEmpty) {
      return const AdminPageContainer(
        child: EmptyStateCard(
          title: 'No courses available for video management',
          message: 'Create a course first. Only added courses appear in the video management selector.',
        ),
      );
    }

    final selectedCourseId = _selectedCourseId ?? widget.store.courses.first.id;
    final videos = widget.store.videosForCourse(selectedCourseId);

    return AdminPageContainer(
      child: ListView(
        children: [
          SectionHeader(
            title: 'Video Management',
            subtitle: 'Upload, reorder, publish, and configure demo access for lecture videos.',
            action: AccentButton(
              label: 'Upload Video',
              icon: Icons.cloud_upload_outlined,
              onPressed: () => _openUploadDialog(context, selectedCourseId),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCourseId,
                  decoration: const InputDecoration(labelText: 'Course'),
                  items: widget.store.courses
                      .map(
                        (course) => DropdownMenuItem(
                          value: course.id,
                          child: Text(course.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedCourseId = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (videos.isEmpty)
            const EmptyStateCard(
              title: 'No videos for this course',
              message: 'Upload the first lecture to initialize sequence and publishing controls.',
            )
          else
            SurfaceCard(
              child: Column(
                children: [
                  for (final video in videos) ...[
                    _VideoRow(
                      video: video,
                      onMoveUp: () => _confirmReorder(context, video, -1),
                      onMoveDown: () => _confirmReorder(context, video, 1),
                      onTogglePublish: () => _confirmTogglePublish(context, video),
                      onToggleDemo: () => _confirmToggleDemo(context, video),
                    ),
                    if (video != videos.last) const Divider(color: BrandColors.border),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openUploadDialog(BuildContext context, String courseId) async {
    String selectedCourseId = courseId;
    final titleController = TextEditingController();
    final durationController = TextEditingController(text: '22:00');
    final orderController = TextEditingController(
      text: (widget.store.videosForCourse(selectedCourseId).length + 1).toString(),
    );
    bool isDemo = false;
    bool uploading = false;

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
                  'Upload Video',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                if (uploading) ...[
                  const LinearProgressIndicator(color: BrandColors.accent),
                  const SizedBox(height: 18),
                  const Text('Uploading video and waiting for processing status...'),
                ] else ...[
                  DropdownButtonFormField<String>(
                    value: selectedCourseId,
                    decoration: const InputDecoration(labelText: 'Course'),
                    items: widget.store.courses
                        .map(
                          (course) => DropdownMenuItem(
                            value: course.id,
                            child: Text(course.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() {
                        selectedCourseId = value;
                        orderController.text =
                            (widget.store.videosForCourse(selectedCourseId).length + 1)
                                .toString();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: durationController,
                          decoration: const InputDecoration(labelText: 'Duration'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: orderController,
                          decoration: const InputDecoration(labelText: 'Order Number'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: isDemo,
                    title: const Text('Mark as demo lecture'),
                    onChanged: (value) => setDialogState(() => isDemo = value),
                  ),
                ],
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
                      label: uploading ? 'Processing...' : 'Start Upload',
                      onPressed: uploading
                          ? null
                          : () async {
                              setDialogState(() => uploading = true);
                              await Future<void>.delayed(const Duration(milliseconds: 1000));
                              widget.store.createVideo(
                                VideoItem(
                                  id: 'video_${DateTime.now().millisecondsSinceEpoch}',
                                  courseId: selectedCourseId,
                                  title: titleController.text.trim(),
                                  duration: durationController.text.trim(),
                                  order: int.tryParse(orderController.text.trim()) ?? 1,
                                  published: false,
                                  isDemo: isDemo,
                                  processingState: 'Processing',
                                ),
                              );
                              if (mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Upload queued in static mode.')),
                                );
                              }
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

  Future<void> _confirmReorder(BuildContext context, VideoItem video, int direction) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reorder Lecture',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text('This updates sequence integrity for "${video.title}".'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: direction < 0 ? 'Move Up' : 'Move Down',
                onPressed: () {
                  widget.store.moveVideo(video.id, direction);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmTogglePublish(BuildContext context, VideoItem video) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.published ? 'Unpublish Lecture' : 'Publish Lecture',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text('This static action changes visibility for "${video.title}".'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: video.published ? 'Unpublish' : 'Publish',
                onPressed: () {
                  widget.store.updateVideo(video.copyWith(
                    published: !video.published,
                    processingState: !video.published ? 'Published' : 'Draft',
                  ));
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmToggleDemo(BuildContext context, VideoItem video) async {
    await showAdminDialog<void>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.isDemo ? 'Remove Demo Access' : 'Mark Demo Lecture',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            const Text('Flow rule reminder: demo access should only apply to early lectures that are intended to be free.'),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: AccentButton(
                label: video.isDemo ? 'Remove Demo' : 'Enable Demo',
                onPressed: () {
                  widget.store.updateVideo(video.copyWith(isDemo: !video.isDemo));
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _VideoRow extends StatelessWidget {
  const _VideoRow({
    required this.video,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onTogglePublish,
    required this.onToggleDemo,
  });

  final VideoItem video;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onTogglePublish;
  final VoidCallback onToggleDemo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: BrandColors.accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              video.order.toString(),
              style: const TextStyle(fontWeight: FontWeight.w800, color: BrandColors.accent),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  '${video.duration} • ${video.processingState}',
                  style: const TextStyle(color: BrandColors.textSecondary),
                ),
              ],
            ),
          ),
          StatusChip(
            label: video.published ? 'Published' : 'Draft',
            color: video.published ? BrandColors.success : BrandColors.warning,
          ),
          const SizedBox(width: 8),
          StatusChip(
            label: video.isDemo ? 'Demo' : 'Locked',
            color: video.isDemo ? BrandColors.accent : BrandColors.textSecondary,
          ),
          const SizedBox(width: 16),
          IconButton(onPressed: onMoveUp, icon: const Icon(Icons.arrow_upward)),
          IconButton(onPressed: onMoveDown, icon: const Icon(Icons.arrow_downward)),
          TextButton(onPressed: onTogglePublish, child: const Text('Publish')),
          TextButton(onPressed: onToggleDemo, child: const Text('Demo')),
        ],
      ),
    );
  }
}
