part of 'suggestions_cubit.dart';

abstract class SuggestionsState extends Equatable {
  const SuggestionsState();

  @override
  List<Object?> get props => [];
}

class SuggestionsInitial extends SuggestionsState {
  const SuggestionsInitial();
}

class SuggestionsLoaded extends SuggestionsState {
  final Map<String, dynamic> currentMeal;
  final String currentCategory;
  final bool isFavorite;
  final bool isSwipeInProgress;

  const SuggestionsLoaded(
    this.currentMeal,
    this.currentCategory, {
    this.isFavorite = false,
    this.isSwipeInProgress = false,
  });

  SuggestionsLoaded copyWith({
    Map<String, dynamic>? currentMeal,
    String? currentCategory,
    bool? isFavorite,
    bool? isSwipeInProgress,
  }) {
    return SuggestionsLoaded(
      currentMeal ?? this.currentMeal,
      currentCategory ?? this.currentCategory,
      isFavorite: isFavorite ?? this.isFavorite,
      isSwipeInProgress: isSwipeInProgress ?? this.isSwipeInProgress,
    );
  }

  @override
  List<Object?> get props => [
    currentMeal,
    currentCategory,
    isFavorite,
    isSwipeInProgress,
  ];
}
