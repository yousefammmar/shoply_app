part of 'favorites_cubit.dart';
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState{}

class FavoritesLoading extends FavoritesState{}

class FavoritesSuccess extends FavoritesState
{
  final Set<String> favoriteIds;

  FavoritesSuccess(this.favoriteIds);
}

class FavoritesError extends FavoritesState
{
  final String message;

  FavoritesError(this.message);

}