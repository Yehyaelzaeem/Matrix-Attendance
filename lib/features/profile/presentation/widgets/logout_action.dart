import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/session_scope.dart';
import '../../../auth/logic/auth_cubit.dart';

class LogoutAction {
  LogoutAction._();

  static Future<void> run(BuildContext context) async {
    final navigator = Navigator.of(context);
    await context.read<AuthCubit>().logout();
    navigator.pushNamedAndRemoveUntil(Routes.loginScreen, (_) => false);
    await SessionScope.restart();
  }
}
