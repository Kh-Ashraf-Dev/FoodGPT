import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  void setCurrentStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void setObscurePassword(bool obscure) {
    emit(state.copyWith(obscurePassword: obscure));
  }

  void setObscureConfirmPassword(bool obscure) {
    emit(state.copyWith(obscureConfirmPassword: obscure));
  }

  void setAcceptTerms(bool accept) {
    emit(state.copyWith(acceptTerms: accept));
  }

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  Future<void> register() async {
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(isLoading: false));
  }
}
