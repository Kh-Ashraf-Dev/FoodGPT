import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recipe_detail_state.dart';

class RecipeDetailCubit extends Cubit<RecipeDetailState> {
  RecipeDetailCubit() : super(const RecipeDetailInitial());

  void toggleStep(int index) {
    final currentState = state;
    if (currentState is RecipeDetailLoaded) {
      final completedSteps = Set<int>.from(currentState.completedSteps);
      if (completedSteps.contains(index)) {
        completedSteps.remove(index);
      } else {
        completedSteps.add(index);
      }
      emit(RecipeDetailLoaded(completedSteps));
    }
  }
}
