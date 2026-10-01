import '../../../core/utils/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import 'models/task_enums.dart';
import 'models/task_model.dart';

class TasksRepo {
  late final List<TaskModel> _tasks = _seed();

  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_tasks);
  }

  Future<TaskModel> save(TaskModel task) async {
    await Future.delayed(AppConstants.mockLatency ~/ 3);
    final i = _tasks.indexWhere((t) => t.id == task.id);
    if (i == -1) {
      _tasks.insert(0, task);
    } else {
      _tasks[i] = task;
    }
    return task;
  }

  Future<void> delete(String id) async {
    await Future.delayed(AppConstants.mockLatency ~/ 3);
    _tasks.removeWhere((t) => t.id == id);
  }

  String nextId() =>
      'T${101 + _tasks.length + DateTime.now().millisecond % 90}';

  static List<TaskModel> _seed() {
    DateTime d(int n) => DateHelper.fromToday(n);
    final rows = <(
      String,
      String,
      String,
      TaskStatus,
      TaskPriority,
      int,
      double,
      double,
      int?
    )>[
      (
        'zwaj',
        'شاشة البروفايل وتعديل البيانات',
        'أحمد محمد',
        TaskStatus.doing,
        TaskPriority.high,
        2,
        12,
        9,
        null
      ),
      (
        'zwaj',
        'ربط الدفع الإلكتروني (Moyasar)',
        'محمود حسن',
        TaskStatus.doing,
        TaskPriority.high,
        4,
        16,
        6,
        null
      ),
      (
        'zwaj',
        'API فلترة الترشيحات بالمدينة والعمر',
        'محمود حسن',
        TaskStatus.done,
        TaskPriority.med,
        -6,
        10,
        11,
        -7
      ),
      (
        'zwaj',
        'تصميم شاشات الاشتراكات',
        'منة الله سمير',
        TaskStatus.done,
        TaskPriority.med,
        -10,
        8,
        7,
        -10
      ),
      (
        'zwaj',
        'اختبار رحلة التسجيل كاملة',
        'سارة علي',
        TaskStatus.review,
        TaskPriority.high,
        1,
        6,
        5,
        null
      ),
      (
        'zwaj',
        'إشعارات الرسائل الجديدة (FCM)',
        'أحمد محمد',
        TaskStatus.todo,
        TaskPriority.med,
        6,
        8,
        0,
        null
      ),
      (
        'zwaj',
        'تحسين سرعة لوحة التحكم',
        'محمود حسن',
        TaskStatus.todo,
        TaskPriority.low,
        9,
        6,
        0,
        null
      ),
      (
        'zwaj',
        'إصلاح رفع الصور على iOS',
        'أحمد محمد',
        TaskStatus.done,
        TaskPriority.high,
        -3,
        4,
        6,
        -2
      ),
      (
        'zwaj',
        'تقرير اختبار النسخة التجريبية',
        'سارة علي',
        TaskStatus.todo,
        TaskPriority.med,
        11,
        5,
        0,
        null
      ),
      (
        'zwaj',
        'اجتماع متابعة مع العميل',
        'يوسف خالد',
        TaskStatus.done,
        TaskPriority.low,
        -1,
        1,
        1.5,
        -1
      ),
      (
        'injox',
        'إعداد بيئة Staging على AWS',
        'خالد وليد',
        TaskStatus.done,
        TaskPriority.high,
        -12,
        10,
        8,
        -14
      ),
      (
        'injox',
        'شاشة الحضور في تطبيق الموظف',
        'مصطفى جمال',
        TaskStatus.doing,
        TaskPriority.high,
        -2,
        14,
        15,
        null
      ),
      (
        'injox',
        'لوحة التحكم: تقارير التشغيل',
        'آية إبراهيم',
        TaskStatus.doing,
        TaskPriority.med,
        5,
        18,
        10,
        null
      ),
      (
        'injox',
        'Automation لسيناريوهات الدخول',
        'نورهان طارق',
        TaskStatus.review,
        TaskPriority.med,
        3,
        8,
        7,
        null
      ),
      (
        'injox',
        'API الفواتير الشهرية',
        'محمود حسن',
        TaskStatus.todo,
        TaskPriority.high,
        7,
        12,
        0,
        null
      ),
      (
        'injox',
        'تحسين أداء قاعدة البيانات',
        'خالد وليد',
        TaskStatus.todo,
        TaskPriority.med,
        -1,
        6,
        2,
        null
      ),
      (
        'injox',
        'تصميم الـ Onboarding',
        'آية إبراهيم',
        TaskStatus.done,
        TaskPriority.low,
        -8,
        6,
        5,
        -9
      ),
      (
        'injox',
        'تخطيط Sprint 7',
        'هبة مصطفى',
        TaskStatus.done,
        TaskPriority.low,
        -4,
        2,
        2,
        -4
      ),
      (
        'injox',
        'إصلاح أخطاء الـ Push Notifications',
        'مصطفى جمال',
        TaskStatus.done,
        TaskPriority.high,
        -6,
        5,
        7,
        -4
      ),
      (
        'cafe',
        'شاشة الطلبات للجرسون',
        'كريم عادل',
        TaskStatus.test,
        TaskPriority.high,
        1,
        10,
        11,
        null
      ),
      (
        'cafe',
        'طباعة الفاتورة على طابعة حرارية',
        'عمر فاروق',
        TaskStatus.doing,
        TaskPriority.high,
        3,
        8,
        5,
        null
      ),
      (
        'cafe',
        'تقرير الوردية اليومي',
        'عمر فاروق',
        TaskStatus.todo,
        TaskPriority.med,
        6,
        6,
        0,
        null
      ),
      (
        'cafe',
        'ربط التابلت بالـ API',
        'أحمد محمد',
        TaskStatus.done,
        TaskPriority.med,
        -5,
        6,
        5,
        -6
      ),
      (
        'cafe',
        'تجهيز نسخة التسليم',
        'يوسف خالد',
        TaskStatus.todo,
        TaskPriority.high,
        7,
        3,
        0,
        null
      ),
      (
        'clinic',
        'تصميم شاشة حجز الموعد',
        'منة الله سمير',
        TaskStatus.done,
        TaskPriority.med,
        -15,
        8,
        8,
        -15
      ),
      (
        'clinic',
        'شات بوت الأسئلة الشائعة',
        'أحمد محمد',
        TaskStatus.todo,
        TaskPriority.med,
        20,
        16,
        0,
        null
      ),
      (
        'clinic',
        'خطة اختبار التطبيق',
        'سارة علي',
        TaskStatus.done,
        TaskPriority.low,
        -12,
        4,
        4,
        -11
      ),
      (
        'clinic',
        'متابعة بيانات الدكاترة مع العميل',
        'هبة مصطفى',
        TaskStatus.doing,
        TaskPriority.high,
        -3,
        2,
        1,
        null
      ),
      (
        'crm',
        'تسليم الدليل التشغيلي للعميل',
        'عمر فاروق',
        TaskStatus.done,
        TaskPriority.med,
        -21,
        4,
        3,
        -21
      ),
      (
        'crm',
        'اختبار الأداء النهائي',
        'نورهان طارق',
        TaskStatus.done,
        TaskPriority.high,
        -24,
        6,
        6,
        -25
      ),
      (
        'crm',
        'تدريب فريق العميل',
        'آية إبراهيم',
        TaskStatus.done,
        TaskPriority.low,
        -20,
        3,
        4,
        -20
      ),
      (
        'zwaj',
        'مراجعة تصميم شاشة المحادثة',
        'منة الله سمير',
        TaskStatus.doing,
        TaskPriority.med,
        3,
        5,
        2,
        null
      ),
      (
        'injox',
        'كتابة توثيق الـ API',
        'هبة مصطفى',
        TaskStatus.todo,
        TaskPriority.low,
        12,
        4,
        0,
        null
      ),
    ];
    final tasks = <TaskModel>[
      for (var i = 0; i < rows.length; i++)
        TaskModel(
          id: 'T${101 + i}',
          projectId: rows[i].$1,
          title: rows[i].$2,
          assignee: rows[i].$3,
          status: rows[i].$4,
          priority: rows[i].$5,
          due: d(rows[i].$6),
          estimate: rows[i].$7,
          spent: rows[i].$8,
          doneAt: rows[i].$9 == null ? null : d(rows[i].$9!),
        ),
    ];
    TaskModel patch(String id, TaskModel Function(TaskModel t) f) {
      final i = tasks.indexWhere((t) => t.id == id);
      return tasks[i] = f(tasks[i]);
    }

    patch(
        'T101',
        (t) => t.copyWith(
              description:
                  'الشاشة فيها: الصورة، البيانات الأساسية، التفضيلات، وزرار تعديل. محتاجة تتربط بالـ API الجديد.',
              attachments: const [
                TaskAttachment(
                    name: 'Profile-API-Spec.pdf', type: AttachmentType.doc),
              ],
              comments: const [
                TaskComment(
                    by: 'يوسف خالد',
                    text:
                        'ياريت الصورة الشخصية تبقى دايرة زي التصميم الجديد، والتعديل يفتح في Bottom Sheet.',
                    at: 'امبارح 4:10 م'),
                TaskComment(
                    by: 'أحمد محمد',
                    text: 'تمام، هعدّلها وأرفع سكرين النهارده.',
                    at: 'امبارح 4:32 م'),
              ],
            ));
    patch(
        'T102',
        (t) => t.copyWith(
            description:
                'بوابة Moyasar للاشتراكات الشهرية والسنوية + Webhook لتأكيد الدفع.'));
    patch(
        'T105',
        (t) => t.copyWith(comments: const [
              TaskComment(
                  by: 'سارة علي',
                  text:
                      'اختبرت التسجيل على Android و iOS، فاضل سيناريو رقم موبايل مسجل قبل كده.',
                  at: 'النهارده 11:05 ص'),
            ]));
    patch(
        'T112',
        (t) => t.copyWith(returns: 1, returned: true, comments: const [
              TaskComment(
                  text: 'مصطفى سلّمها للمراجعة',
                  at: 'امبارح',
                  kind: CommentKind.system),
              TaskComment(
                  by: 'مريم عادل',
                  text:
                      'الـ Check-in بيقبل موقع وهمي (Mock Location)، لازم نكشفه ونمنع التسجيل.',
                  at: 'امبارح 6:20 م',
                  kind: CommentKind.returned),
            ]));
    patch(
        'T120',
        (t) => t.copyWith(returns: 2, comments: const [
              TaskComment(
                  by: 'مريم عادل',
                  text: 'زرار إلغاء الطلب مش شغال لو الطلب اتبعت للمطبخ.',
                  at: 'من 3 أيام',
                  kind: CommentKind.returned),
              TaskComment(
                  by: 'كريم عادل',
                  text: 'اتصلحت ورفعت نسخة جديدة.',
                  at: 'امبارح 2:00 م'),
              TaskComment(
                  text: 'مريم حوّلتها للتست',
                  at: 'النهارده 10:30 ص',
                  kind: CommentKind.system),
            ]));
    patch(
        'T114',
        (t) => t.copyWith(comments: const [
              TaskComment(
                  text: 'نورهان سلّمتها للمراجعة',
                  at: 'النهارده 9:40 ص',
                  kind: CommentKind.system),
            ]));
    return tasks;
  }
}
