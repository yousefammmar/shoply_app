part of '../../main_screen.dart';

class _MainDrawer extends StatelessWidget {
  const _MainDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 330,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                spacing: 15,
                children: [
                  Container(
                    height: 95,
                    width: 95,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: CustomCachedImageNetwork(
                      errorWidget: Image(
                        image: AssetImage(AppImages.profilePicture),
                      ),
                      image: LocalStorageUser.instance.profileImage,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        LocalStorageUser.instance.fullName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        LocalStorageUser.instance.email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(thickness: 0.1, color: Colors.grey),
              SizedBox(height: 20),
              CustomListTile(
                iconData: Icons.shopping_bag_outlined,
                title: 'My Orders',
              ),
              SizedBox(height: 20),
              CustomListTile(
                iconData: Icons.settings_outlined,
                title: 'Settings',
              ),
              SizedBox(height: 20),
              CustomListTile(iconData: Icons.info_outline, title: 'About'),
              Spacer(),
              CustomListTile(
                iconData: Icons.logout,
                title: 'Logout',
                color: Colors.red,
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
