import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/pages/creategroup.dart';
import 'package:todo_list/pages/about.dart' as about_page;
import 'package:todo_list/widgets/custombody.dart';
import 'package:todo_list/providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<CustomBodyState> customBodyKey;
  final ValueNotifier<Color> colorNotifier;

  const CustomAppBar({
    super.key,
    required this.customBodyKey,
    required this.colorNotifier,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ValueListenableBuilder<Color>(
      valueListenable: colorNotifier,
      builder: (context, color, child) {
        return AppBar(
          toolbarHeight: 100,
          backgroundColor: color,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text(
              "My Todo List",
              style: TextStyle(
                fontFamily: 'PlaywriteDEGrund',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 23, 0),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 40),
                offset: const Offset(0, 50), // Position menu below the button
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (String value) async {
                  // Handle menu item selection
                  switch (value) {
                    case 'group':
                      final result = await showCreateGroupDialog(context);
                      if (result != null) {
                        // Add the group to the body
                        customBodyKey.currentState?.addGroup(result);
                      }
                      break;
                    case 'Theme':
                      themeProvider.toggleTheme();
                      break;
                    case 'About':
                      about_page.showAboutDialog(context);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'group',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('Group'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Theme',
                    child: Row(
                      children: [
                        Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'About',
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.grey),
                        SizedBox(width: 10),
                        Text('About'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
