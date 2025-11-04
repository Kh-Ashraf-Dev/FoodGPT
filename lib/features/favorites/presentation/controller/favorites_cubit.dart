import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/managers/favourite_manager.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());

    try {
      final favorites = await FavoritesManager.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  Future<void> removeFavorite(String mealName, int index) async {
    final removed = await FavoritesManager.removeFromFavorites(mealName);
    if (removed) {
      final currentState = state;
      if (currentState is FavoritesLoaded) {
        final updatedFavorites = List<Map<String, dynamic>>.from(
          currentState.favorites,
        );
        updatedFavorites.removeAt(index);
        emit(FavoritesLoaded(updatedFavorites));
      }
    }
  }
}
