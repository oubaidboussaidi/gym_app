import 'package:flutter/material.dart';
import 'package:gym_app/screens/settings.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/widgets/drawer_title.dart';

class CustomDrawer extends StatelessWidget {
  final AuthService _authService = serviceLocator<AuthService>();
  CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // logo
            Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 25),
              child: Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            Divider(color: Theme.of(context).colorScheme.secondary),
            DrawerTitle(
              text: "Home",
              icon: Icons.home,
              onTap: () => Navigator.pop(context),
            ),
            DrawerTitle(
              text: "Settings",
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ),
            ),
            const Spacer(),
            DrawerTitle(
              text: "Logout",
              icon: Icons.logout,
              onTap: () => _authService.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
