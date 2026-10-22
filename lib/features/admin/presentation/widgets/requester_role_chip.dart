import 'package:flutter/material.dart';

import '../../../../core/widgets/status_chip.dart';
import '../../../auth/data/models/user_role.dart';

class RequesterRoleChip extends StatelessWidget {
  const RequesterRoleChip(this.role, {super.key});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final shown = role == UserRole.reviewer ? role : UserRole.employee;
    return StatusChip(
      small: true,
      label: '${shown.emoji} ${shown.label}',
      tone: shown.tone,
    );
  }
}
