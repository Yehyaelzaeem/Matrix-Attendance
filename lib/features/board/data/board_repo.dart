import '../../../core/models/day_type.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import 'models/board_entry.dart';

class BoardRepo {
  static const List<BoardEntry> _today = [
    BoardEntry(
        name: 'أحمد محمد',
        jobTitle: 'Flutter Developer',
        status: BoardStatus.present,
        location: DayType.office,
        checkIn: '8:52'),
    BoardEntry(
        name: 'سارة علي',
        jobTitle: 'QA Tester',
        status: BoardStatus.late,
        location: DayType.office,
        checkIn: '9:47',
        note: 'متأخرة 47 د'),
    BoardEntry(
        name: 'محمود حسن',
        jobTitle: 'Backend (Laravel)',
        status: BoardStatus.paused,
        location: DayType.home,
        checkIn: '8:58',
        note: '⏸ كهربا · من 25 د'),
    BoardEntry(
        name: 'منة الله سمير',
        jobTitle: 'UI/UX Designer',
        status: BoardStatus.present,
        location: DayType.home,
        checkIn: '9:04'),
    BoardEntry(
        name: 'يوسف خالد',
        jobTitle: 'Project Manager',
        status: BoardStatus.present,
        location: DayType.office,
        checkIn: '8:40'),
    BoardEntry(
        name: 'كريم عادل',
        jobTitle: 'Android Developer',
        status: BoardStatus.absent,
        location: DayType.office),
    BoardEntry(
        name: 'نورهان طارق',
        jobTitle: 'Automation Tester',
        status: BoardStatus.late,
        location: DayType.home,
        checkIn: '10:12',
        note: 'متأخرة 72 د · بإذن'),
    BoardEntry(
        name: 'عمر فاروق',
        jobTitle: 'Full Stack Developer',
        status: BoardStatus.out,
        location: DayType.office,
        checkIn: '8:30',
        checkOut: '4:35',
        note: 'اشتغل 8:05'),
    BoardEntry(
        name: 'هبة مصطفى', jobTitle: 'Scrum Master', status: BoardStatus.leave),
    BoardEntry(
        name: 'مصطفى جمال',
        jobTitle: 'iOS Developer',
        status: BoardStatus.present,
        location: DayType.office,
        checkIn: '9:00'),
    BoardEntry(
        name: 'آية إبراهيم',
        jobTitle: 'Frontend (Vue)',
        status: BoardStatus.present,
        location: DayType.home,
        checkIn: '8:55'),
    BoardEntry(
        name: 'خالد وليد',
        jobTitle: 'DevOps Engineer',
        status: BoardStatus.absent,
        location: DayType.home),
  ];

  BoardDay todaySnapshot() => const BoardDay(daysAgo: 0, entries: _today);

  Future<BoardDay> getDay(int daysAgo) async {
    await Future.delayed(AppConstants.mockLatency);
    if (daysAgo == 0) return todaySnapshot();
    final entries = <BoardEntry>[];
    for (var i = 0; i < _today.length; i++) {
      final e = _today[i];
      final r = (i * 7 + daysAgo * 3) % 10;
      final pad = DateHelper.twoDigits;
      if (r < 6) {
        final isHome = e.location == DayType.home;
        entries.add(BoardEntry(
          name: e.name,
          jobTitle: e.jobTitle,
          status: BoardStatus.out,
          location: e.location ?? DayType.office,
          checkIn: '8:${pad(30 + r * 4)}',
          checkOut: isHome ? '6:${pad(35 + r * 3)}' : '4:${pad(40 + r * 3)}',
          note: 'اشتغل ${isHome ? '10' : '8'}:${pad(r * 2)}',
        ));
      } else if (r < 8) {
        entries.add(BoardEntry(
          name: e.name,
          jobTitle: e.jobTitle,
          status: BoardStatus.out,
          location: e.location ?? DayType.office,
          checkIn: '9:${pad(20 + r * 4)}',
          checkOut: '5:40',
          note: 'متأخر ${20 + r * 4} د',
          isLate: true,
        ));
      } else if (r == 8) {
        entries.add(BoardEntry(
            name: e.name,
            jobTitle: e.jobTitle,
            status: BoardStatus.leave,
            note: 'إجازة'));
      } else {
        entries.add(BoardEntry(
          name: e.name,
          jobTitle: e.jobTitle,
          status: BoardStatus.out,
          location: e.location ?? DayType.office,
          checkIn: '8:50',
          checkOut: '3:10',
          note: '⚠️ ناقص 40 د',
        ));
      }
    }
    return BoardDay(daysAgo: daysAgo, entries: entries);
  }
}
