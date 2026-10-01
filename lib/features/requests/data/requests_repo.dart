import '../../../core/utils/app_constants.dart';
import 'models/request_model.dart';

class RequestsRepo {
  final List<RequestModel> _mine = [
    const RequestModel(
      id: 'r1',
      type: RequestType.swap,
      title: 'الأحد 4 أكتوبر من البيت',
      subtitle: 'بدل الشركة',
      status: RequestStatus.pending,
      reason: 'عندي صيانة في البيت ومحتاج أبقى موجود.',
      when: 'من ساعتين',
    ),
    const RequestModel(
      id: 'r2',
      type: RequestType.late,
      title: 'إذن تأخير – الخميس',
      subtitle: 'الحضور 11:30',
      status: RequestStatus.approved,
      reason: 'مشوار في المرور لتجديد الرخصة.',
      when: 'من 3 أيام',
      decidedBy: 'أ. يوسف',
    ),
    const RequestModel(
      id: 'r3',
      type: RequestType.leave,
      title: 'إجازة 3 أيام',
      subtitle: '12 – 14 أكتوبر',
      status: RequestStatus.rejected,
      reason: 'ظروف عائلية.',
      when: 'من أسبوع',
      rejectReason: 'التاريخ ده وقت تسليم مشروع INJOX، ممكن نأجلها أسبوع؟',
    ),
    const RequestModel(
      id: 'r4',
      type: RequestType.fix,
      title: 'تعديل انصراف – الاثنين',
      subtitle: 'الانصراف الفعلي 5:10',
      status: RequestStatus.approved,
      reason: 'نسيت أعمل Check-out.',
      when: 'من أسبوعين',
      decidedBy: 'المراجع',
    ),
  ];

  Future<List<RequestModel>> getMyRequests() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_mine);
  }

  Future<RequestModel> submit(RequestModel request) async {
    await Future.delayed(AppConstants.mockLatency);
    _mine.insert(0, request);
    return request;
  }
}
