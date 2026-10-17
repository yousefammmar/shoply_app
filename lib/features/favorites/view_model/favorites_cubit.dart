
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepo favoritesRepo;

  StreamSubscription<Set<String>>? _subscription;

  FavoritesCubit({required this.favoritesRepo})
      : super(FavoritesInitial());

  void loadFavorites() {
    emit(FavoritesLoading());

    try {
      _subscription?.cancel();

      _subscription = favoritesRepo.watchFavorites().listen(
        (favoriteIds) {
          emit(FavoritesSuccess(favoriteIds));
        },
        onError: (error) {
          emit(FavoritesError(error.toString()));
        },
      );
    } catch (error) {
      emit(FavoritesError(error.toString()));
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final currentState = state;

    if (currentState is! FavoritesSuccess) return;

    try {
      if (currentState.favoriteIds.contains(productId)) {
        await favoritesRepo.removeFavorite(productId);
      } else {
        await favoritesRepo.addFavorite(productId);
      }
    } catch (error) {
      emit(FavoritesError(error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
