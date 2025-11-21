import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:gym_app/service_locator.dart";
import "package:gym_app/services/theme.dart";

class Settings extends StatelessWidget {
  Settings({super.key});

  final ThemeService _themeService = serviceLocator<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings Page",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                AnimatedBuilder(
                  animation: _themeService,
                  builder: (_, __) {
                    return CupertinoSwitch(
                      value: _themeService.isDarkMode,
                      onChanged: (value) {
                        _themeService.toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
