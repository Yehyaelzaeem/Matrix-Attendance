import '../../../../core/utils/locale_keys.dart';

class JobTitle {
  const JobTitle(this.emoji, this.title);

  final String emoji;
  final String title;
}

class JobGroup {
  const JobGroup(this.labelKey, this.items);

  final String labelKey;
  final List<JobTitle> items;
}

const List<JobGroup> kJobGroups = [
  JobGroup(LocaleKeys.auth_jobGroupProgramming, [
    JobTitle('📱', 'Flutter Developer'),
    JobTitle('🤖', 'Android Developer'),
    JobTitle('🍎', 'iOS Developer'),
    JobTitle('🧩', 'Backend Developer (Laravel)'),
    JobTitle('🟩', 'Backend Developer (Node.js)'),
    JobTitle('🎨', 'Frontend Developer (Vue / React)'),
    JobTitle('🧠', 'Full Stack Developer'),
    JobTitle('⚙️', 'DevOps Engineer'),
  ]),
  JobGroup(LocaleKeys.auth_jobGroupQa, [
    JobTitle('🧪', 'QA Tester (Manual)'),
    JobTitle('🤖', 'Automation Tester'),
    JobTitle('📱', 'Mobile App Tester'),
  ]),
  JobGroup(LocaleKeys.auth_jobGroupManagement, [
    JobTitle('📋', 'Project Manager'),
    JobTitle('🛠️', 'Technical Project Manager'),
    JobTitle('🔁', 'Scrum Master'),
    JobTitle('📝', 'Business Analyst'),
  ]),
  JobGroup(LocaleKeys.auth_jobGroupDesign, [
    JobTitle('✏️', 'UI/UX Designer'),
    JobTitle('🖌️', 'Graphic Designer'),
  ]),
];
