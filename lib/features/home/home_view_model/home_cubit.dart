
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int selectedCategoryIndex = 0;

  void changeCategory({required int index}) {
    selectedCategoryIndex = index;
    emit(HomeCategoryChanged(index));
  }

  Future<void> loadProducts() async {
    emit(HomeLoading());

    try {
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void resetCategory() {
    selectedCategoryIndex = 0;
    emit(HomeCategoryChanged(0));
  }
}
