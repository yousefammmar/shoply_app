
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shoply_app/features/home/home_view_model/home_cubit.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_banner.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_categories.dart';
import 'package:shoply_app/features/home/presentation/widgets/trending_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
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
              HomeBanner(),
              SizedBox(height: 24),
              HomeCategories(),
              SizedBox(height: 24),
              TrendingProducts(),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
