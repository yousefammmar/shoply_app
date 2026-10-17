
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Core - Navigation
import 'package:shoply_app/core/navigation/cubit/main_cubit.dart';
import 'package:shoply_app/core/navigation/cubit/main_state.dart';
import 'package:shoply_app/core/navigation/widget/shoply_bottom_nav_bar.dart';

// Core - Local Storage & Routes
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/local/local_storage_user.dart';
import 'package:shoply_app/core/routes/app_pages.dart';

// Core - Shared Widgets
import 'package:shoply_app/core/utils/widgets/drawer/app_drawer.dart';

// Core - Repository
import 'package:shoply_app/core/repositories/category_repository.dart';

// Features - Home
import 'package:shoply_app/features/home/view/home_screen.dart';
import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';

// Features - Categories
import 'package:shoply_app/features/categories/view/categories_screen.dart';
import 'package:shoply_app/features/categories/view_model/categories_cubit.dart';

// Features - Products
import 'package:shoply_app/features/products/repo/products_repo.dart';
import 'package:shoply_app/features/products/view_model/products_cubit.dart';
// Features - Favorites
import 'package:shoply_app/features/favorites/repo/favorites_repo.dart';
import 'package:shoply_app/features/favorites/view_model/favorites_cubit.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  // ================= LOGOUT =================

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      await LocalStorage.instance.setIsLogin(
        isLogin: false,
      );

      await LocalStorageUser.instance.clearUserData();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppPages.loginScreen,
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
        ),
      );
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesCubit>(
      create: (_) => FavoritesCubit(
        favoritesRepo: FavoritesRepo(),
      )..loadFavorites(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final mainCubit = context.read<MainCubit>();

          return Scaffold(
            backgroundColor: Colors.white,

            // ================= APP BAR =================

            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                switch (mainCubit.selectedIndex) {
                  0 => 'Shoply',
                  1 => 'Categories',
                  2 => 'Favorites',
                  3 => 'Cart',
                  _ => 'Shoply',
                },
                style: const TextStyle(
                  color: Color(0xFF07583F),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: Builder(
                builder: (scaffoldContext) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color(0xFF07583F),
                    ),
                    onPressed: () {
                      Scaffold.of(scaffoldContext).openDrawer();
                    },
                  );
                },
              ),
            ),

            // ================= SIDEBAR =================

            drawer: AppDrawer(
              onLogout: () => _logout(context),
            ),

            // ================= PAGES =================

            body: IndexedStack(
              index: mainCubit.selectedIndex,
              children: [
                // Home + Products Cubits
                MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeCubit>(
                      create: (_) => HomeCubit(),
                    ),
                    BlocProvider<ProductsCubit>(
                      create: (_) => ProductsCubit(
                        productsRepo: ProductsRepo(),
                      )..getProducts(),
                    ),
                  ],
                  child: const HomeScreen(),
                ),

                // Categories
                BlocProvider<CategoriesCubit>(
                  create: (_) => CategoriesCubit(
                    CategoryRepository(),
                  )..loadCategories(),
                  child: const CategoriesScreen(),
                ),

                // Favorites (temporary)
                const Center(
                  child: Text(
                    'Favorites - Coming Soon',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                // Cart (temporary)
                const Center(
                  child: Text(
                    'Cart - Coming Soon',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),

            // ================= BOTTOM NAVIGATION =================

            bottomNavigationBar: ShoplyBottomNavBar(
              selectedIndex: mainCubit.selectedIndex,
              onTabChange: mainCubit.changeTab,
            ),
          );
        },
      )
    );
  }
}
