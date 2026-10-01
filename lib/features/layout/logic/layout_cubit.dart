import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_tab.dart';

class LayoutCubit extends Cubit<AppTab> {
  LayoutCubit() : super(AppTab.home);

  List<AppTab> _tabs = const [];

  bool has(AppTab tab) => _tabs.contains(tab);

  void start(List<AppTab> tabs) {
    _tabs = tabs;
    emit(tabs.first);
  }

  void select(AppTab tab) {
    if (has(tab)) emit(tab);
  }
}
