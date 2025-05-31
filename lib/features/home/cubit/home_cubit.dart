import 'package:bloc/bloc.dart';
import 'package:flutter_task_app/features/home/cubit/home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void changeTab(int index) {
    if (index != state.tabIndex) {
      emit(HomeTabChanged(index));
    }
  }
}
