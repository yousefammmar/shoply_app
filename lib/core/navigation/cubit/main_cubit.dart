import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_state.dart';

class MainCubit extends Cubit<MainState>
{
  MainCubit(): super(MainInitial());
  int selectedIndex=0;
  void changeTab(int index)
  {
    //__ if the index was out of bounds
    if(index<0||index>3)return;
    //__ if the page I'm in is the one I want to go to
    if(index==selectedIndex)return;
    //__ go to a new page
    selectedIndex=index;
    emit(MainTabChanged(index));
  }
}