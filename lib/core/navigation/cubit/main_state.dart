abstract class MainState{}

class MainInitial extends MainState{}

class MainTabChanged extends MainState
{

  final int selectedIndex;

  MainTabChanged(this.selectedIndex);

}