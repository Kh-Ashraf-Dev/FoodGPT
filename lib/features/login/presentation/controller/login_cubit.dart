import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void setObscurePassword(bool obscure) {
    emit(state.copyWith(obscurePassword: obscure));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isLoading: false));
  }
}
