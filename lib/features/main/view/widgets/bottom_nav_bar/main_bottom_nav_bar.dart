part of '../../main_screen.dart';

class _MainBottomNavBar extends StatelessWidget {
  const _MainBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      buildWhen: (previous, current) {
        return current is MainChangeNavBarIndexState;
      },
      builder: (context, state) {
        final cubit = context.read<MainCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1, thickness: 0.4, color: Colors.grey),
            NavigationBar(
              selectedIndex: cubit.navBarIndex,
              onDestinationSelected: (index) {
                cubit.changeNavBarIndex(index: index);
              },
              indicatorShape: CircleBorder(),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),

                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'Favorite',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: 'Cart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_outlined),
                  selectedIcon: Icon(Icons.person_2),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
