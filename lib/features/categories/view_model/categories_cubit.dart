
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/core/repositories/category_repository.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository _repository;

  CategoriesCubit(this._repository) : super(CategoriesInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());

    try {
      final categories = await _repository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
