import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/suggestions_model.dart';

part 'suggestions_state.dart';

class SuggestionsCubit extends Cubit<SuggestionsState> {
  SuggestionsCubit({String? category})
    : _initialCategory = category,
      super(const SuggestionsInitial()) {
    _loadInitialMeal();
  }

  final String? _initialCategory;
  final _random = Random();
  final _categories = const ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناكس', 'صحي'];

  void _loadInitialMeal() {
    final category =
        _initialCategory ?? _categories[_random.nextInt(_categories.length)];
    final meal = SuggestionData.getRandomMeal(category);
    emit(SuggestionsLoaded(meal, category));
  }

  void suggestNewMeal(String? excludeMealName) {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      final category =
          _initialCategory ?? _categories[_random.nextInt(_categories.length)];
      final meal = SuggestionData.getRandomMeal(
        category,
        excludeMealName: excludeMealName,
      );
      emit(SuggestionsLoaded(meal, category, isFavorite: false));
    }
  }

  void setFavorite(bool isFavorite) {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      emit(currentState.copyWith(isFavorite: isFavorite));
    }
  }

  void setSwipeInProgress(bool inProgress) {
    final currentState = state;
    if (currentState is SuggestionsLoaded) {
      emit(currentState.copyWith(isSwipeInProgress: inProgress));
    }
  }
}
