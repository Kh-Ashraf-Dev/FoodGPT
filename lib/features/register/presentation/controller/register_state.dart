part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final int currentStep;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool acceptTerms;
  final bool isLoading;

  const RegisterState({
    this.currentStep = 0,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.acceptTerms = false,
    this.isLoading = false,
  });

  RegisterState copyWith({
    int? currentStep,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    bool? acceptTerms,
    bool? isLoading,
  }) {
    return RegisterState(
      currentStep: currentStep ?? this.currentStep,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    obscurePassword,
    obscureConfirmPassword,
    acceptTerms,
    isLoading,
  ];
}
