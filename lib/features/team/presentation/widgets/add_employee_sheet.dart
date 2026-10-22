import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../data/models/employee_model.dart';
import '../../logic/add_employee_cubit.dart';
import 'add_employee_form.dart';

class AddEmployeeSheet extends StatelessWidget {
  const AddEmployeeSheet({super.key, this.onCreated});

  final ValueChanged<EmployeeModel>? onCreated;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt<AddEmployeeCubit>(),
        child: AddEmployeeForm(onCreated: onCreated),
      );
}
