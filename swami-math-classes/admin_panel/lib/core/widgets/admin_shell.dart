import 'package:flutter/material.dart';

import '../../features/courses/courses_feature.dart';
import '../../features/dashboard/dashboard_feature.dart';
import '../../features/notifications/notifications_feature.dart';
import '../../features/reports/reports_feature.dart';
import '../../features/students/students_feature.dart';
import '../../features/videos/videos_feature.dart';
import '../data/admin_mock_store.dart';
import '../models/admin_models.dart';
import 'admin_components.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({
    required this.store,
    required this.currentSection,
    required this.onSectionChanged,
    required this.onLogout,
    super.key,
  });

  final AdminMockStore store;
  final AdminSection currentSection;
  final ValueChanged<AdminSection> onSectionChanged;
  final VoidCallback onLogout;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool _sidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              _Sidebar(
                currentSection: widget.currentSection,
                onSectionChanged: widget.onSectionChanged,
                onLogout: widget.onLogout,
                isCollapsed: _sidebarCollapsed,
                onToggleCollapse: () {
                  setState(() {
                    _sidebarCollapsed = !_sidebarCollapsed;
                  });
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(section: widget.currentSection),
                    Expanded(
                      child: switch (widget.currentSection) {
                        AdminSection.dashboard => DashboardFeature(store: widget.store),
                        AdminSection.courses => CoursesFeature(store: widget.store),
                        AdminSection.videos => VideosFeature(store: widget.store),
                        AdminSection.students => StudentsFeature(store: widget.store),
                        AdminSection.notifications =>
                          NotificationsFeature(store: widget.store),
                        AdminSection.reports => ReportsFeature(store: widget.store),
                        AdminSection.settings => const _SettingsFeature(),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.currentSection,
    required this.onSectionChanged,
    required this.onLogout,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  final AdminSection currentSection;
  final ValueChanged<AdminSection> onSectionChanged;
  final VoidCallback onLogout;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final items = <({AdminSection section, IconData icon, String label})>[
      (section: AdminSection.dashboard, icon: Icons.dashboard_outlined, label: 'Dashboard'),
      (section: AdminSection.courses, icon: Icons.menu_book_outlined, label: 'Courses'),
      (section: AdminSection.videos, icon: Icons.play_circle_outline, label: 'Videos'),
      (section: AdminSection.students, icon: Icons.people_outline, label: 'Students'),
      (section: AdminSection.notifications, icon: Icons.notifications_outlined, label: 'Notifications'),
      (section: AdminSection.reports, icon: Icons.bar_chart_outlined, label: 'Reports'),
      (section: AdminSection.settings, icon: Icons.settings_outlined, label: 'Settings'),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: isCollapsed ? 92 : 280,
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(right: BorderSide(color: BrandColors.border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: isCollapsed
                        ? const SizedBox.shrink()
                        : const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Navigation',
                              style: TextStyle(
                                color: BrandColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                ),
                IconButton(
                  onPressed: onToggleCollapse,
                  icon: Icon(
                    isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: BrandColors.textSecondary,
                  ),
                  tooltip: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
                ),
              ],
            ),
          ),
          _BrandBlock(isCollapsed: isCollapsed),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 12 : 18),
              children: [
                for (final item in items) ...[
                  _SidebarButton(
                    icon: item.icon,
                    label: item.label,
                    selected: item.section == currentSection,
                    isCollapsed: isCollapsed,
                    onTap: () => onSectionChanged(item.section),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isCollapsed ? 12 : 18),
            child: SurfaceCard(
              padding: EdgeInsets.all(isCollapsed ? 10 : 16),
              child: isCollapsed
                  ? Column(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: BrandColors.accent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'AD',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          onPressed: onLogout,
                          icon: const Icon(Icons.logout, color: BrandColors.textSecondary),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            color: BrandColors.accent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'AD',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Administrator', style: TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text(
                                'admin@smc.edu.in',
                                style: TextStyle(color: BrandColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onLogout,
                          icon: const Icon(Icons.logout, color: BrandColors.textSecondary),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isCollapsed,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? BrandColors.accent.withOpacity(0.18) : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 0 : 18,
            vertical: 16,
          ),
          child: Row(
            mainAxisAlignment:
                isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: selected ? BrandColors.accent : BrandColors.textSecondary,
              ),
              if (!isCollapsed) ...[
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? BrandColors.textPrimary : BrandColors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock({required this.isCollapsed});

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 24),
      child: AdminBrandLogo(
        width: isCollapsed ? 54 : 190,
        showSubtitle: !isCollapsed,
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.section});

  final AdminSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(bottom: BorderSide(color: BrandColors.border)),
      ),
      child: Row(
        children: [
          Text(
            switch (section) {
              AdminSection.dashboard => 'Dashboard',
              AdminSection.courses => 'Course Management',
              AdminSection.videos => 'Video Management',
              AdminSection.students => 'Student Management',
              AdminSection.notifications => 'Notification Management',
              AdminSection.reports => 'Reports & Export',
              AdminSection.settings => 'Settings',
            },
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: BrandColors.textSecondary),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: BrandColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SettingsFeature extends StatelessWidget {
  const _SettingsFeature();

  @override
  Widget build(BuildContext context) {
    return const AdminPageContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Settings',
            subtitle: 'Static desktop settings surface for this UI-only phase.',
          ),
          SizedBox(height: 24),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin session policy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: 12),
                Text('Session expiry, role enforcement, and notification preferences are displayed here as static controls until backend integration.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
