part of 'recipe_detail_cubit.dart';

abstract class RecipeDetailState extends Equatable {
  const RecipeDetailState();

  @override
  List<Object?> get props => [];
}

class RecipeDetailInitial extends RecipeDetailState {
  const RecipeDetailInitial();
}

class RecipeDetailLoaded extends RecipeDetailState {
  final Set<int> completedSteps;

  const RecipeDetailLoaded(this.completedSteps);

  @override
  List<Object?> get props => [completedSteps];
}
