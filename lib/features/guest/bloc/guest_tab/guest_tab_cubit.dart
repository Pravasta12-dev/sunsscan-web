import 'package:flutter_bloc/flutter_bloc.dart';

enum GuestTab { dashboard, scan, guests, souvenirs, layers, settings }

class GuestTabCubit extends Cubit<GuestTab> {
  GuestTabCubit() : super(GuestTab.dashboard);

  void setTab(GuestTab tab) => emit(tab);
}
