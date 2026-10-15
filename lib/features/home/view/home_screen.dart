
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Local Storage
import 'package:shoply_app/core/local/local_storage.dart';
import 'package:shoply_app/core/local/local_storage_user.dart';

// Routes
import 'package:shoply_app/core/routes/app_pages.dart';

// Common Widgets
import 'package:shoply_app/core/utils/widgets/app_bar/custom_app_bar.dart';

// Home Cubit
import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';

// Home Widgets
import 'package:shoply_app/features/home/presentation/widgets/home_banner.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_categories.dart';
import 'package:shoply_app/features/home/presentation/widgets/trending_products.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ================= LOGOUT =================

  void _logout(BuildContext context) {
    LocalStorage.instance.setIsLogin(isLogin: false);
    LocalStorageUser.instance.clearUserData();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppPages.loginScreen,
      (route) => false,
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= DRAWER =================

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Shoply',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),

      // ================= APP BAR =================

      appBar: CustomAppBar(
        title: const Text('Shoply'),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

      // ================= BODY =================

      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          return current is HomeLoading ||
              current is HomeLoaded ||
              current is HomeError;
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                HomeBanner(),

                SizedBox(height: 24),

                // Categories
                HomeCategories(),

                SizedBox(height: 24),

                // Trending Products
                TrendingProducts(),

                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),

      // ================= BOTTOM NAVIGATION =================

      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          return current is HomeTabChanged;
        },
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          return HomeBottomNavBar(
            selectedIndex: cubit.selectedTabIndex,
            onTabChange: cubit.changeTab,
          );
        },
      ),
    );
  }
}
