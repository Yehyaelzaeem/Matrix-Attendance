import 'package:flutter/material.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/utils/date_helper.dart';
import 'models/project_model.dart';

class ProjectsRepo {
  late final List<ProjectModel> _projects = _seed();

  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(AppConstants.mockLatency);
    return List.unmodifiable(_projects);
  }

  Future<ProjectModel> save(ProjectModel project) async {
    await Future.delayed(AppConstants.mockLatency ~/ 3);
    final i = _projects.indexWhere((p) => p.id == project.id);
    if (i == -1) {
      _projects.insert(0, project);
    } else {
      _projects[i] = project;
    }
    return project;
  }

  static List<ProjectModel> _seed() {
    DateTime d(int n) => DateHelper.fromToday(n);
    return [
      ProjectModel(
        id: 'zwaj',
        name: 'Zwaj',
        kind: 'منصة زواج إسلامي · تطبيق + لوحة تحكم',
        color: const Color(0xff0f67f6),
        status: ProjectStatus.active,
        description:
            'منصة لترشيح شريك الحياة بضوابط شرعية: تسجيل بالبيانات والتفضيلات، ترشيحات ذكية، محادثة بموافقة ولي الأمر، واشتراكات مدفوعة. التطبيق Flutter ولوحة التحكم Laravel + Filament.',
        manager: 'يوسف خالد',
        team: const [
          TeamMember('يوسف خالد', 'PM'),
          TeamMember('أحمد محمد', 'Flutter'),
          TeamMember('محمود حسن', 'Backend'),
          TeamMember('منة الله سمير', 'UI/UX'),
          TeamMember('سارة علي', 'QA'),
        ],
        client: const ClientInfo(
            name: 'م. خالد الشمري',
            company: 'مؤسسة أُسرة',
            phone: '+966 55 123 4567',
            email: 'khaled@usrh.sa',
            city: 'الرياض، السعودية'),
        currency: 'ر.س',
        value: 120000,
        payments: [
          PaymentModel(
              label: 'دفعة التعاقد 30%',
              amount: 36000,
              due: d(-120),
              paid: true,
              paidAt: d(-119)),
          PaymentModel(
              label: 'تسليم التصميمات 20%',
              amount: 24000,
              due: d(-60),
              paid: true,
              paidAt: d(-58)),
          PaymentModel(
              label: 'النسخة التجريبية 30%', amount: 36000, due: d(12)),
          PaymentModel(label: 'التسليم النهائي 20%', amount: 24000, due: d(45)),
        ],
        start: d(-125),
        beta: d(12),
        due: d(45),
        contract: ContractInfo(
            number: 'MC-2026-014',
            signedAt: d(-128),
            months: 6,
            fileName: 'Zwaj-Contract-Signed.pdf',
            notes: 'الصيانة مجانية 3 شهور بعد التسليم.'),
      ),
      ProjectModel(
        id: 'injox',
        name: 'INJOX',
        kind: 'نظام تشغيل متعدد الشركات (SaaS) · ويب + موبايل',
        color: const Color(0xff7c3aed),
        status: ProjectStatus.active,
        description:
            'منصة SaaS لإدارة العمليات اليومية لأكتر من شركة: الموظفين، الحضور، المهام، الفواتير والتقارير، مع تطبيق موبايل للموظف ولوحة تحكم لكل شركة.',
        manager: 'هبة مصطفى',
        team: const [
          TeamMember('هبة مصطفى', 'PM'),
          TeamMember('محمود حسن', 'Backend'),
          TeamMember('مصطفى جمال', 'iOS'),
          TeamMember('آية إبراهيم', 'Frontend'),
          TeamMember('خالد وليد', 'DevOps'),
          TeamMember('نورهان طارق', 'QA'),
        ],
        client: const ClientInfo(
            name: 'أ. رامي عبد العزيز',
            company: 'INJOX Technologies',
            phone: '+20 100 555 2211',
            email: 'rami@injox.io',
            city: 'القاهرة الجديدة'),
        currency: 'ج.م',
        value: 850000,
        payments: [
          PaymentModel(
              label: 'المرحلة الأولى 30%',
              amount: 255000,
              due: d(-90),
              paid: true,
              paidAt: d(-88)),
          PaymentModel(
              label: 'المرحلة الثانية 25%', amount: 212500, due: d(-5)),
          PaymentModel(
              label: 'المرحلة الثالثة 25%', amount: 212500, due: d(30)),
          PaymentModel(label: 'التسليم 20%', amount: 170000, due: d(75)),
        ],
        start: d(-100),
        beta: d(20),
        due: d(75),
        contract: ContractInfo(
            number: 'MC-2026-009',
            signedAt: d(-104),
            months: 7,
            fileName: 'INJOX-Agreement.pdf',
            notes: 'غرامة تأخير 1% أسبوعياً بحد أقصى 10%.'),
      ),
      ProjectModel(
        id: 'cafe',
        name: 'Cafe Cash',
        kind: 'كاشير وإدارة طلبات لقهوة بلدي · تابلت',
        color: const Color(0xffea580c),
        status: ProjectStatus.active,
        description:
            'نظام للجرسونات على التابلت: الطلبات حسب الترابيزة، طباعة الفاتورة، وتقرير الوردية اليومي لصاحب القهوة.',
        manager: 'يوسف خالد',
        team: const [
          TeamMember('يوسف خالد', 'PM'),
          TeamMember('عمر فاروق', 'Full Stack'),
          TeamMember('كريم عادل', 'Android'),
          TeamMember('أحمد محمد', 'Flutter'),
        ],
        client: const ClientInfo(
            name: 'الحاج سيد عبد الله',
            company: 'قهوة البلد',
            phone: '+20 122 333 4455',
            email: '—',
            city: 'السيدة زينب، القاهرة'),
        currency: 'ج.م',
        value: 65000,
        payments: [
          PaymentModel(
              label: 'مقدم 50%',
              amount: 32500,
              due: d(-40),
              paid: true,
              paidAt: d(-40)),
          PaymentModel(label: 'عند التسليم 50%', amount: 32500, due: d(8)),
        ],
        start: d(-42),
        beta: d(-3),
        due: d(8),
        contract:
            ContractInfo(number: 'MC-2026-021', signedAt: d(-43), months: 2),
      ),
      ProjectModel(
        id: 'clinic',
        name: 'عيادات ودكاترة',
        kind: 'حجز مواعيد العيادات + شات بوت',
        color: const Color(0xff0891b2),
        status: ProjectStatus.hold,
        description:
            'تطبيق لحجز مواعيد الدكاترة في فروع المجموعة، مع شات بوت يرد على أسئلة المرضى. متوقف لحد ما العميل يبعت قائمة الدكاترة والأسعار.',
        manager: 'هبة مصطفى',
        team: const [
          TeamMember('هبة مصطفى', 'PM'),
          TeamMember('أحمد محمد', 'Flutter'),
          TeamMember('منة الله سمير', 'UI/UX'),
          TeamMember('سارة علي', 'QA'),
        ],
        client: const ClientInfo(
            name: 'د. منى فؤاد',
            company: 'مجموعة عيادات الشفاء',
            phone: '+20 111 777 8899',
            email: 'mona@elshefa.com',
            city: 'الإسكندرية'),
        currency: 'ج.م',
        value: 140000,
        payments: [
          PaymentModel(
              label: 'مقدم 40%',
              amount: 56000,
              due: d(-30),
              paid: true,
              paidAt: d(-29)),
          PaymentModel(label: 'النسخة الأولى 30%', amount: 42000, due: d(25)),
          PaymentModel(label: 'التسليم 30%', amount: 42000, due: d(60)),
        ],
        start: d(-32),
        beta: d(25),
        due: d(60),
        contract: ContractInfo(
            number: 'MC-2026-019',
            signedAt: d(-33),
            months: 3,
            fileName: 'Elshefa-Contract.pdf'),
      ),
      ProjectModel(
        id: 'crm',
        name: 'Matrix CRM',
        kind: 'نظام إدارة عملاء لشركة عقارات',
        color: const Color(0xff16a34a),
        status: ProjectStatus.delivered,
        description:
            'CRM لمتابعة العملاء والوحدات والمبيعات لفريق مبيعات من 40 شخص، مع تقارير يومية للإدارة.',
        manager: 'يوسف خالد',
        team: const [
          TeamMember('يوسف خالد', 'PM'),
          TeamMember('عمر فاروق', 'Full Stack'),
          TeamMember('آية إبراهيم', 'Frontend'),
          TeamMember('نورهان طارق', 'QA'),
        ],
        client: const ClientInfo(
            name: 'م. هشام ناصر',
            company: 'AMHZ Group',
            phone: '+20 100 222 9090',
            email: 'hesham@amhz-group.com',
            city: 'التجمع الخامس'),
        currency: 'ج.م',
        value: 210000,
        payments: [
          PaymentModel(
              label: 'مقدم 40%',
              amount: 84000,
              due: d(-150),
              paid: true,
              paidAt: d(-150)),
          PaymentModel(
              label: 'تسليم أولي 30%',
              amount: 63000,
              due: d(-60),
              paid: true,
              paidAt: d(-57)),
          PaymentModel(
              label: 'التسليم النهائي 30%',
              amount: 63000,
              due: d(-20),
              paid: true,
              paidAt: d(-18)),
        ],
        start: d(-155),
        beta: d(-60),
        due: d(-21),
        delivered: d(-20),
        contract: ContractInfo(
            number: 'MC-2026-003',
            signedAt: d(-158),
            months: 5,
            fileName: 'AMHZ-CRM-Contract.pdf'),
      ),
    ];
  }
}
