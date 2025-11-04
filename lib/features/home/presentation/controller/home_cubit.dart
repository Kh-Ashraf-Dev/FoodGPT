import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void setCurrentIndex(int index) {
    emit(HomeIndexChanged(index));
  }

  void resetIndex() {
    emit(const HomeIndexChanged(0));
  }
}
