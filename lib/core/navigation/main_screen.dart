import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/core/navigation/cubit/main_cubit.dart';
import 'package:shoply_app/core/navigation/cubit/main_state.dart';

import 'package:shoply_app/core/repositories/category_repository.dart';

import 'package:shoply_app/features/home/view/home_screen.dart';
import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_bottom_nav_bar.dart';

import 'package:shoply_app/features/categories/view/categories_screen.dart';
import 'package:shoply_app/features/categories/view_model/categories_cubit.dart';

class MainScreen extends StatelessWidget
{
  const MainScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    return BlocBuilder<MainCubit, MainState>
    (
      builder: (context,state)
      {
        final mainCubit=context.read<MainCubit>();
        return Scaffold
        (
          body: IndexedStack
          (
            index: mainCubit.selectedIndex,
            children: 
            [
              BlocProvider
              (
                create:(_)=>HomeCubit(),
                child: const HomeScreen()
              ),
              BlocProvider
              (
                create: (_)=>CategoriesCubit(CategoryRepository())..loadCategories(),
                child: const CategoriesScreen()
              ),
              const Center
              (
                child: Text('Favorites - coming soon')
              ),
              const Center
              (
                child: Text('Cart - coming soon')
              )
            ]
          ),
          bottomNavigationBar: HomeBottomNavBar
          (
            selectedIndex: mainCubit.selectedIndex,
            onTabChange: mainCubit.changeTab,
          ),
        );
      }
    );
  }
}