part of 'login_cubit.dart';

class LoginState extends Equatable {
  final bool obscurePassword;
  final bool isLoading;

  const LoginState({this.obscurePassword = true, this.isLoading = false});

  LoginState copyWith({bool? obscurePassword, bool? isLoading}) {
    return LoginState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [obscurePassword, isLoading];
}
