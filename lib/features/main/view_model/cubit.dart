import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoply_app/features/home/view/home_screen.dart';
import 'package:shoply_app/features/main/view_model/state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitState());
  int navBarIndex = 0;

  List<Widget> page = [
    HomeScreen(),
    Text('categories'),
    Text('Favourite'),
    Text('Cart'),
  ];

  void changeNavBarIndex({required int index}) {
    navBarIndex = index;
    emit(MainChangeNavBarIndexState());
  }
}
