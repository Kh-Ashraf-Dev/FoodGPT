part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeIndexChanged extends HomeState {
  final int currentIndex;

  const HomeIndexChanged(this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}
