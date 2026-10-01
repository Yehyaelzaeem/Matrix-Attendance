import '../../../core/utils/app_constants.dart';
import '../../requests/data/models/request_model.dart';
import 'models/approval_models.dart';

class ApprovalsRepo {
  final List<RequestModel> _requests = [
    const RequestModel(
      id: 'a1',
      employee: 'أحمد محمد',
      type: RequestType.swap,
      title: 'الأحد 4 أكتوبر من البيت',
      subtitle: 'بدل الشركة',
      status: RequestStatus.pending,
      reason: 'عندي صيانة في البيت ومحتاج أبقى موجود.',
      when: 'من ساعتين',
    ),
    const RequestModel(
      id: 'a2',
      employee: 'سارة علي',
      type: RequestType.late,
      title: 'إذن تأخير – بكرة',
      subtitle: 'الحضور 11:00',
      status: RequestStatus.pending,
      reason: 'عندي ميعاد دكتور الصبح.',
      when: 'من 40 دقيقة',
    ),
    const RequestModel(
      id: 'a3',
      employee: 'كريم عادل',
      type: RequestType.leave,
      title: 'إجازة يومين',
      subtitle: '7 – 8 أكتوبر',
      status: RequestStatus.pending,
      reason: 'فرح أخويا في المنصورة.',
      when: 'امبارح',
    ),
    const RequestModel(
      id: 'a4',
      employee: 'عمر فاروق',
      type: RequestType.fix,
      title: 'تعديل انصراف – الاثنين',
      subtitle: 'الانصراف الفعلي 5:40',
      status: RequestStatus.pending,
      reason: 'النت فصل ومعرفتش أعمل Check-out.',
      when: 'امبارح',
    ),
  ];

  final List<NewAccountModel> _accounts = [
    const NewAccountModel(
        name: 'ياسمين حسام',
        phone: '01098765432',
        jobTitle: 'QA Tester (Manual)',
        when: 'من ساعة'),
    const NewAccountModel(
        name: 'زياد محمود',
        phone: '01156781234',
        jobTitle: 'Flutter Developer',
        when: 'من 3 ساعات'),
  ];

  final List<ApprovalLogEntry> _log = [
    const ApprovalLogEntry(
        name: 'منة الله سمير',
        what: 'إذن انصراف مبكر',
        outcome: LogOutcome.approved,
        when: 'امبارح'),
    const ApprovalLogEntry(
        name: 'خالد وليد',
        what: 'تبديل مكان',
        outcome: LogOutcome.rejected,
        when: 'من يومين',
        reason: 'يوم ديمو العميل'),
  ];

  Future<(List<RequestModel>, List<NewAccountModel>, List<ApprovalLogEntry>)>
      getAll() async {
    await Future.delayed(AppConstants.mockLatency);
    return (List.of(_requests), List.of(_accounts), List.of(_log));
  }

  Future<void> decideRequest(String id, ApprovalLogEntry entry) async {
    await Future.delayed(AppConstants.mockLatency);
    _requests.removeWhere((r) => r.id == id);
    _log.insert(0, entry);
  }

  Future<void> decideAccount(String name, ApprovalLogEntry entry) async {
    await Future.delayed(AppConstants.mockLatency);
    _accounts.removeWhere((a) => a.name == name);
    _log.insert(0, entry);
  }
}
