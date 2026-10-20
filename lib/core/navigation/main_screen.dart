import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoply_app/core/navigation/cubit/main_cubit.dart';
import 'package:shoply_app/core/navigation/cubit/main_state.dart';
import 'package:shoply_app/core/navigation/widget/shoply_bottom_nav_bar.dart';
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/local/local_storage_user.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/widgets/drawer/app_drawer.dart';
import 'package:shoply_app/core/repositories/category_repository.dart';
import 'package:shoply_app/features/home/view/home_screen.dart';
import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';
import 'package:shoply_app/features/categories/view/categories_screen.dart';
import 'package:shoply_app/features/categories/view_model/categories_cubit.dart';
import 'package:shoply_app/features/products/repo/products_repo.dart';
import 'package:shoply_app/features/products/view_model/products_cubit.dart';
import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';
import 'package:shoply_app/features/favorites/view_model/favorites_cubit.dart';
import 'package:shoply_app/features/favorites/view/favorites_screen.dart';
import 'package:shoply_app/features/cart/view/cart_screen.dart';
import 'package:shoply_app/features/orders/view/order_history_screen.dart';
import 'package:shoply_app/features/profile/view/profile_screen.dart';
import 'package:shoply_app/features/settings/view/settings_screen.dart';
import 'package:shoply_app/features/about/view/about_screen.dart';
import 'package:shoply_app/core/utils/widgets/dialog/app_confirmation_dialog.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static const green = Color(0xFF07583F);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await LocalStorage.instance.setIsLogin(isLogin: false);
      await LocalStorageUser.instance.clearUserData();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppPages.loginScreen, (route) => false);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
      }
    }
  }
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppConfirmationDialog.show(
      context: context,
      title: 'Logout?',
      message:
          'Are you sure you want to logout of your Shoply account?',
      confirmText: 'Logout',
      cancelText: 'Stay',
      icon: Icons.logout_rounded,
      isDangerous: true,
    );

    if (!confirmed || !context.mounted) return;

    await _logout(context);
  }
  void _openPage(BuildContext context, Widget page) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    Navigator.of(context).push(PageRouteBuilder<void>(
      transitionDuration: reduced ? Duration.zero : const Duration(milliseconds: 340),
      reverseTransitionDuration: reduced ? Duration.zero : const Duration(milliseconds: 260),
      pageBuilder: (context, animation, secondary) => page,
      transitionsBuilder: (context, animation, secondary, child) {
        final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: curve,
          child: SlideTransition(position: Tween<Offset>(
            begin: const Offset(.06, 0), end: Offset.zero).animate(curve), child: child));
      },
    ));
  }

  @override
  Widget build(BuildContext context) => BlocProvider<FavoritesCubit>(
    create: (_) => FavoritesCubit(favoritesRepo: FavoritesRepo())..loadFavorites(),
    child: BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      final mainCubit = context.read<MainCubit>();
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(switch (mainCubit.selectedIndex) {
            0 => 'Shoply', 1 => 'Categories', 2 => 'Favorites', 3 => 'Cart', _ => 'Shoply',
          }, style: const TextStyle(color: green, fontSize: 20, fontWeight: FontWeight.bold)),
          leading: Builder(builder: (scaffoldContext) => IconButton(
            icon: const Icon(Icons.menu, color: green),
            onPressed: () => Scaffold.of(scaffoldContext).openDrawer(),
          )),
        ),
        drawer: AppDrawer(
          onLogout: () => _confirmLogout(context),
          onProfile: () => _openPage(context, const ProfileScreen()),
          onOrders: () => _openPage(context, const OrderHistoryScreen()),
          onFavorites: () => mainCubit.changeTab(2),
          onSettings: () => _openPage(context, const SettingsScreen()),
          onAbout: () => _openPage(context, const AboutScreen()),
        ),
        body: IndexedStack(index: mainCubit.selectedIndex, children: [
          MultiBlocProvider(providers: [
            BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
            BlocProvider<ProductsCubit>(create: (_) => ProductsCubit(productsRepo: ProductsRepo())..getProducts()),
          ], child: const HomeScreen()),
          BlocProvider<CategoriesCubit>(
            create: (_) => CategoriesCubit(CategoryRepository())..loadCategories(),
            child: const CategoriesScreen(),
          ),
          const FavoritesScreen(),
          const CartScreen(),
        ]),
        bottomNavigationBar: ShoplyBottomNavBar(
          selectedIndex: mainCubit.selectedIndex,
          onTabChange: mainCubit.changeTab,
        ),
      );
    }),
  );
}
