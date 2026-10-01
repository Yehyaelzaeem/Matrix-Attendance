import '../../../core/utils/app_constants.dart';
import 'models/decision_model.dart';

class DecisionsRepo {
  final List<DecisionModel> _items = [
    const DecisionModel(
      id: 'd1',
      kind: DecisionKind.decision,
      title: 'تعديل مواعيد يوم الخميس',
      body:
          'بداية من الشهر الجاي، يوم الخميس الحضور من البيت للكل، والاجتماع الأسبوعي الساعة 12 أونلاين.',
      when: 'النهارده 10:15 ص',
      by: 'الإدارة',
      audience: DecisionAudience.all,
      doneCount: 15,
      pendingNames: [
        'كريم عادل',
        'خالد وليد',
        'نورهان طارق',
        'هبة مصطفى',
        'مصطفى جمال'
      ],
    ),
    const DecisionModel(
      id: 'd2',
      kind: DecisionKind.poll,
      title: 'رحلة الشركة السنوية في العين السخنة؟',
      body:
          'بنفكر نعمل رحلة يومين آخر أكتوبر. موافق على المكان والميعاد؟ اكتب اقتراحك لو عندك مكان تاني.',
      when: 'امبارح',
      by: 'الإدارة',
      audience: DecisionAudience.all,
      deadline: 'باقي يومين',
      yes: 9,
      no: 5,
      voters: [
        PollVoter('يوسف خالد', true, 'فكرة حلوة، ياريت نخليها خميس وجمعة'),
        PollVoter('سارة علي', false, 'أفضل الساحل الشمالي'),
        PollVoter('محمود حسن', true),
        PollVoter('آية إبراهيم', true, 'موافقة جداً'),
        PollVoter('كريم عادل', false, 'الميعاد قريب من تسليم INJOX'),
      ],
    ),
    const DecisionModel(
      id: 'd3',
      kind: DecisionKind.info,
      title: 'إجازة رسمية: 6 أكتوبر',
      body:
          'يوم الثلاثاء 6 أكتوبر إجازة رسمية بمناسبة عيد القوات المسلحة. كل سنة وانتم طيبين 🇪🇬',
      when: 'من 3 أيام',
      by: 'الإدارة',
      audience: DecisionAudience.all,
      acked: true,
      doneCount: 18,
    ),
  ];

  Future<List<DecisionModel>> getDecisions() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_items);
  }

  Future<DecisionModel> save(DecisionModel decision) async {
    await Future.delayed(AppConstants.mockLatency ~/ 3);
    final i = _items.indexWhere((d) => d.id == decision.id);
    if (i == -1) {
      _items.insert(0, decision);
    } else {
      _items[i] = decision;
    }
    return decision;
  }
}
