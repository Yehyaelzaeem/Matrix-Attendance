import '../../../core/models/day_type.dart';
import '../../../core/utils/app_constants.dart';
import '../../auth/data/models/user_role.dart';
import 'models/employee_model.dart';
import 'models/holiday_model.dart';

class TeamRepo {
  final List<EmployeeModel> _employees = [
    const EmployeeModel(name: 'أحمد محمد', jobTitle: 'Flutter Developer'),
    const EmployeeModel(name: 'سارة علي', jobTitle: 'QA Tester'),
    const EmployeeModel(name: 'محمود حسن', jobTitle: 'Backend (Laravel)'),
    const EmployeeModel(name: 'منة الله سمير', jobTitle: 'UI/UX Designer'),
    const EmployeeModel(
        name: 'يوسف خالد', jobTitle: 'Project Manager', role: UserRole.admin),
    const EmployeeModel(name: 'كريم عادل', jobTitle: 'Android Developer'),
    const EmployeeModel(name: 'نورهان طارق', jobTitle: 'Automation Tester'),
    const EmployeeModel(name: 'عمر فاروق', jobTitle: 'Full Stack Developer'),
    const EmployeeModel(
        name: 'هبة مصطفى', jobTitle: 'Scrum Master', role: UserRole.reviewer),
    const EmployeeModel(name: 'مصطفى جمال', jobTitle: 'iOS Developer'),
    const EmployeeModel(name: 'آية إبراهيم', jobTitle: 'Frontend (Vue)'),
    const EmployeeModel(name: 'خالد وليد', jobTitle: 'DevOps Engineer'),
  ];

  final List<HolidayModel> _holidays = [
    HolidayModel(
        date: DateTime(DateTime.now().year, 10, 6), name: 'عيد القوات المسلحة'),
    HolidayModel(
        date: DateTime(DateTime.now().year, 12, 25),
        name: 'إجازة رأس السنة (عيد الميلاد)'),
    HolidayModel(
        date: DateTime(DateTime.now().year + 1, 1, 7),
        name: 'عيد الميلاد المجيد'),
  ];

  Future<List<EmployeeModel>> getEmployees() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_employees);
  }

  Future<List<HolidayModel>> getHolidays() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_holidays);
  }

  Future<EmployeeModel> updateEmployee(
    String name, {
    UserRole? role,
    WeeklySchedule? schedule,
    bool? suspended,
  }) async {
    await Future.delayed(AppConstants.mockLatency);
    final i = _employees.indexWhere((e) => e.name == name);
    final updated = _employees[i]
        .copyWith(role: role, schedule: schedule, suspended: suspended);
    _employees[i] = updated;
    return updated;
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    await Future.delayed(AppConstants.mockLatency);
    _employees.add(employee);
    return employee;
  }

  Future<HolidayModel> addHoliday(DateTime date, String name) async {
    await Future.delayed(AppConstants.mockLatency);
    final holiday = HolidayModel(date: date, name: name);
    _holidays.add(holiday);
    return holiday;
  }
}
