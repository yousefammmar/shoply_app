
part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {}

class HomeCategoryChanged extends HomeState {
  final int categoryIndex;

  HomeCategoryChanged(this.categoryIndex);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
class HomeTabChanged extends HomeState {
  final int index;

  HomeTabChanged(this.index);
}
