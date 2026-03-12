import 'package:flutter/foundation.dart';

import '../models/admin_models.dart';

class AdminMockStore extends ChangeNotifier {
  AdminMockStore.seeded()
      : metrics = [
          DashboardMetric(
            label: 'Total Students',
            value: '12,480',
            delta: '+14.2%',
            positive: true,
          ),
          DashboardMetric(
            label: 'Active Subscriptions',
            value: '8,364',
            delta: '+6.8%',
            positive: true,
          ),
          DashboardMetric(
            label: 'Revenue This Month',
            value: 'Rs. 18.6L',
            delta: '+9.1%',
            positive: true,
          ),
          DashboardMetric(
            label: 'New Subscriptions Today',
            value: '146',
            delta: '-2.1%',
            positive: false,
          ),
        ],
        activities = [
          ActivityItem(
            title: 'Offline subscription assigned',
            subtitle: 'SSC 10th Mathematics assigned to Rohan Patil',
            timestamp: '2 min ago',
          ),
          ActivityItem(
            title: 'Batch end date updated',
            subtitle: 'SSC 10th Math-I extended to 31 Mar 2027',
            timestamp: '18 min ago',
          ),
          ActivityItem(
            title: 'Video upload completed',
            subtitle: 'Quadratic Equations - Lecture 09 published',
            timestamp: '42 min ago',
          ),
        ],
        courses = [
          Course(
            id: 'course_10_ssc',
            name: 'Mathematics Std. 10',
            board: 'SSC Maharashtra',
            standard: '10th',
            price: 12499,
            batchEndDate: DateTime(2027, 3, 31),
            isActive: true,
            folderStructure: 'Dual Folder',
            description: 'Main launch course with Math-I and Math-II structure.',
          ),
          Course(
            id: 'course_9_ssc',
            name: 'Mathematics Std. 9',
            board: 'SSC Maharashtra',
            standard: '9th',
            price: 9999,
            batchEndDate: DateTime(2027, 3, 31),
            isActive: false,
            folderStructure: 'Dual Folder',
            description: 'Pre-launch course scaffold for SSC 9th.',
          ),
          Course(
            id: 'course_10_cbse',
            name: 'Mathematics Class 10',
            board: 'CBSE',
            standard: '10th',
            price: 13999,
            batchEndDate: DateTime(2027, 3, 31),
            isActive: false,
            folderStructure: 'Single Folder',
            description: 'Future launch structure for CBSE batch.',
          ),
        ],
        videos = [
          VideoItem(
            id: 'video_1',
            courseId: 'course_10_ssc',
            title: 'Introduction to Linear Equations',
            duration: '24:18',
            order: 1,
            published: true,
            isDemo: true,
            processingState: 'Published',
          ),
          VideoItem(
            id: 'video_2',
            courseId: 'course_10_ssc',
            title: 'Linear Equations Practice Set',
            duration: '32:06',
            order: 2,
            published: true,
            isDemo: false,
            processingState: 'Published',
          ),
          VideoItem(
            id: 'video_3',
            courseId: 'course_10_ssc',
            title: 'Quadratic Equations Lecture 01',
            duration: '28:54',
            order: 3,
            published: false,
            isDemo: false,
            processingState: 'Processing',
          ),
        ],
        students = [
          StudentRecord(
            id: 'stu_1',
            name: 'Rohan Patil',
            mobile: '9876543210',
            courseName: 'Mathematics Std. 10',
            status: StudentStatus.active,
            deviceId: 'SMC-DEV-1082',
            paymentMode: 'Razorpay',
          ),
          StudentRecord(
            id: 'stu_2',
            name: 'Sneha Kulkarni',
            mobile: '9123456780',
            courseName: 'Mathematics Std. 10',
            status: StudentStatus.paused,
            deviceId: 'SMC-DEV-1044',
            paymentMode: 'Offline',
          ),
          StudentRecord(
            id: 'stu_3',
            name: 'Aarav Deshmukh',
            mobile: '9988776655',
            courseName: 'Mathematics Std. 9',
            status: StudentStatus.active,
            deviceId: 'SMC-DEV-1190',
            paymentMode: 'Offline',
          ),
        ],
        notifications = [
          NotificationItem(
            id: 'ntf_1',
            title: 'Live Doubt Support Window',
            message: 'Support line open from 6 PM to 8 PM today.',
            target: 'All Students',
            schedule: 'Sent instantly',
            status: 'Delivered',
          ),
          NotificationItem(
            id: 'ntf_2',
            title: 'Math-I revision module',
            message: 'New revision module is now live for SSC 10th.',
            target: 'Mathematics Std. 10',
            schedule: '13 Mar 2026, 8:00 AM',
            status: 'Scheduled',
          ),
        ],
        reports = [
          ReportItem(
            id: 'rep_1',
            label: 'Revenue',
            amount: 'Rs. 18,64,500',
            count: '1,482 payments',
          ),
          ReportItem(
            id: 'rep_2',
            label: 'Subscriptions',
            amount: '8,364 active',
            count: '146 today',
          ),
          ReportItem(
            id: 'rep_3',
            label: 'Students',
            amount: '12,480 total',
            count: '412 paused',
          ),
          ReportItem(
            id: 'rep_4',
            label: 'Offline Assignments',
            amount: '1,126 assigned',
            count: '61 this week',
          ),
        ];

  final List<DashboardMetric> metrics;
  final List<ActivityItem> activities;
  final List<Course> courses;
  final List<VideoItem> videos;
  final List<StudentRecord> students;
  final List<NotificationItem> notifications;
  final List<ReportItem> reports;

  void createCourse(Course course) {
    courses.insert(0, course);
    notifyListeners();
  }

  void updateCourse(Course updatedCourse) {
    final index = courses.indexWhere((course) => course.id == updatedCourse.id);
    if (index == -1) {
      return;
    }
    courses[index] = updatedCourse;
    notifyListeners();
  }

  void toggleCourse(String courseId) {
    final index = courses.indexWhere((course) => course.id == courseId);
    if (index == -1) {
      return;
    }
    final course = courses[index];
    courses[index] = course.copyWith(isActive: !course.isActive);
    notifyListeners();
  }

  List<VideoItem> videosForCourse(String courseId) {
    final items = videos.where((video) => video.courseId == courseId).toList();
    items.sort((left, right) => left.order.compareTo(right.order));
    return items;
  }

  void createVideo(VideoItem video) {
    videos.add(video);
    notifyListeners();
  }

  void updateVideo(VideoItem updatedVideo) {
    final index = videos.indexWhere((video) => video.id == updatedVideo.id);
    if (index == -1) {
      return;
    }
    videos[index] = updatedVideo;
    notifyListeners();
  }

  void moveVideo(String videoId, int direction) {
    final sorted = [...videos]..sort((left, right) => left.order.compareTo(right.order));
    final index = sorted.indexWhere((video) => video.id == videoId);
    final targetIndex = index + direction;
    if (index == -1 || targetIndex < 0 || targetIndex >= sorted.length) {
      return;
    }

    final current = sorted[index];
    final target = sorted[targetIndex];
    updateVideo(current.copyWith(order: target.order));
    updateVideo(target.copyWith(order: current.order));
  }

  void toggleStudentStatus(String studentId) {
    final index = students.indexWhere((student) => student.id == studentId);
    if (index == -1) {
      return;
    }
    final student = students[index];
    students[index] = student.copyWith(
      status: student.status == StudentStatus.active
          ? StudentStatus.paused
          : StudentStatus.active,
    );
    notifyListeners();
  }

  void resetDevice(String studentId) {
    final index = students.indexWhere((student) => student.id == studentId);
    if (index == -1) {
      return;
    }
    students[index] = students[index].copyWith(deviceId: 'RESET REQUIRED');
    notifyListeners();
  }

  void assignOfflineCourse({
    required String studentId,
    required String courseName,
  }) {
    final index = students.indexWhere((student) => student.id == studentId);
    if (index == -1) {
      return;
    }
    students[index] = students[index].copyWith(
      courseName: courseName,
      paymentMode: 'Offline',
      status: StudentStatus.active,
    );
    notifyListeners();
  }

  void sendNotification(NotificationItem item) {
    notifications.insert(0, item);
    notifyListeners();
  }
}
