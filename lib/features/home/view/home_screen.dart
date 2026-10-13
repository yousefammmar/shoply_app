import 'package:flutter/material.dart';
import 'package:shoply_app/core/local/local_storage_user.dart';
import 'package:shoply_app/core/routes/app_pages.dart';
import 'package:shoply_app/core/utils/widgets/app_bar/custom_app_bar.dart';
import 'package:shoply_app/features/home/presentation/widgets/home_banner.dart';
import '../../../core/local/local_storage.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  void _logout(BuildContext context)
  {
    LocalStorage.instance.setIsLogin(isLogin: false);
    LocalStorageUser.instance.clearUserData();
    Navigator.pushNamedAndRemoveUntil
      (
        context,
        AppPages.loginScreen,
        (route) => false,
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        drawer: Drawer
          (
            child: SafeArea
              (
                child: SafeArea
                  (
                    child: Column
                      (
                        children:
                        [
                          const ListTile
                            (
                              title: Text
                                (
                                  'Shoply',
                                  style: TextStyle
                                    (
                                    fontSize:24,
                                    fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          const Divider(),
                          ListTile
                            (
                              leading: const Icon(Icons.logout),
                              title: const Text('Logout'),
                              onTap: () => _logout(context),
                            ),
                        ],
                      ),
                  ),
              ),
          ),
      appBar: CustomAppBar
        (
          title:const Text( 'Shoply'),
          leading: Builder
            (
              builder: (context) {
                return IconButton
                  (
                    icon: const Icon(Icons.menu),
                    onPressed: ()
                        {
                          Scaffold.of(context).openDrawer();
                        }
                );
              }
            ),
        ),
      body: const SingleChildScrollView
        (
          padding: EdgeInsets.all(16),
          child: Column
            (
              children:
              [
                HomeBanner(),
              ],
            ),
      )


    );
  }
}
