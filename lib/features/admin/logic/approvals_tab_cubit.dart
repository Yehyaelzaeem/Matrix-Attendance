import 'package:flutter_bloc/flutter_bloc.dart';

enum ApprovalsTab { requests, accounts, log }

class ApprovalsTabCubit extends Cubit<ApprovalsTab> {
  ApprovalsTabCubit() : super(ApprovalsTab.requests);

  void select(ApprovalsTab tab) => emit(tab);
}
