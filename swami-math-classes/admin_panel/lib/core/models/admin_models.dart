enum AuthView {
  login,
  loading,
  invalidCredentials,
  unauthorized,
  sessionExpired,
  networkError,
  authenticated,
}

enum AdminSection {
  dashboard,
  courses,
  videos,
  students,
  notifications,
  reports,
  settings,
}

enum StudentStatus { active, paused }

enum NotificationTarget { allStudents, course, individual }

enum ReportType { revenue, subscriptions, students, offlineAssignments }

enum ExportFormat { csv, excel, pdf }

class DashboardMetric {
  DashboardMetric({
    required this.label,
    required this.value,
    required this.delta,
    required this.positive,
  });

  final String label;
  final String value;
  final String delta;
  final bool positive;
}

class ActivityItem {
  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.timestamp,
  });

  final String title;
  final String subtitle;
  final String timestamp;
}

class Course {
  Course({
    required this.id,
    required this.name,
    required this.board,
    required this.standard,
    required this.price,
    required this.batchEndDate,
    required this.isActive,
    required this.folderStructure,
    required this.description,
  });

  final String id;
  final String name;
  final String board;
  final String standard;
  final int price;
  final DateTime batchEndDate;
  final bool isActive;
  final String folderStructure;
  final String description;

  Course copyWith({
    String? name,
    String? board,
    String? standard,
    int? price,
    DateTime? batchEndDate,
    bool? isActive,
    String? folderStructure,
    String? description,
  }) {
    return Course(
      id: id,
      name: name ?? this.name,
      board: board ?? this.board,
      standard: standard ?? this.standard,
      price: price ?? this.price,
      batchEndDate: batchEndDate ?? this.batchEndDate,
      isActive: isActive ?? this.isActive,
      folderStructure: folderStructure ?? this.folderStructure,
      description: description ?? this.description,
    );
  }
}

class VideoItem {
  VideoItem({
    required this.id,
    required this.courseId,
    required this.title,
    required this.duration,
    required this.order,
    required this.published,
    required this.isDemo,
    required this.processingState,
  });

  final String id;
  final String courseId;
  final String title;
  final String duration;
  final int order;
  final bool published;
  final bool isDemo;
  final String processingState;

  VideoItem copyWith({
    String? title,
    String? duration,
    int? order,
    bool? published,
    bool? isDemo,
    String? processingState,
  }) {
    return VideoItem(
      id: id,
      courseId: courseId,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      published: published ?? this.published,
      isDemo: isDemo ?? this.isDemo,
      processingState: processingState ?? this.processingState,
    );
  }
}

class StudentRecord {
  StudentRecord({
    required this.id,
    required this.name,
    required this.mobile,
    required this.courseName,
    required this.status,
    required this.deviceId,
    required this.paymentMode,
  });

  final String id;
  final String name;
  final String mobile;
  final String courseName;
  final StudentStatus status;
  final String deviceId;
  final String paymentMode;

  StudentRecord copyWith({
    String? name,
    String? mobile,
    String? courseName,
    StudentStatus? status,
    String? deviceId,
    String? paymentMode,
  }) {
    return StudentRecord(
      id: id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      courseName: courseName ?? this.courseName,
      status: status ?? this.status,
      deviceId: deviceId ?? this.deviceId,
      paymentMode: paymentMode ?? this.paymentMode,
    );
  }
}

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.target,
    required this.schedule,
    required this.status,
  });

  final String id;
  final String title;
  final String message;
  final String target;
  final String schedule;
  final String status;
}

class ReportItem {
  ReportItem({
    required this.id,
    required this.label,
    required this.amount,
    required this.count,
  });

  final String id;
  final String label;
  final String amount;
  final String count;
}
