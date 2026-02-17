import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/screens/note_list_screen.dart';
import 'package:pow_note_ai/features/trash_panel/screens/trash_screen.dart';
import 'package:pow_note_ai/features/backup_panel/screens/back_up_screen.dart';
import 'package:pow_note_ai/utils/app_texts.dart';
import '../../utils/app_radius.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int selectedIndex = 0;

  final pages = [
    const NoteListScreen(),
    const TrashScreen(),
    const BackUpScreen(),
    //  const SettingsScreen(),
  ];

  final titles = [
    AppTexts.notes,
    AppTexts.trashList,
    AppTexts.cloudSpace,
    //AppTexts.settings,
  ];

  @override
  Widget build(BuildContext context) {
    final Color defaultColor = Theme.of(context).colorScheme.primary;

    final TextStyle? listTileTextStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: defaultColor);

    final TextStyle? titleStyle = Theme.of(context).textTheme.titleSmall;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[selectedIndex], style: titleStyle),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: defaultColor),
                child: Text('', style: titleStyle),
              ),
              ListTile(
                leading: Icon(Icons.notes, color: defaultColor),
                title: Text(
                  AppTexts.notes,
                  style: listTileTextStyle,
                ),
                onTap: () {
                  setState(() => selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.restore_from_trash_rounded,
                  color: defaultColor,
                ),
                title: Text(
                  AppTexts.trashList,
                  style: listTileTextStyle,
                ),
                onTap: () {
                  setState(() => selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cloud, color: defaultColor),
                title: Text(
                  AppTexts.cloudSpace,
                  style: listTileTextStyle,
                ),
                onTap: () {
                  setState(() => selectedIndex = 2);
                  Navigator.pop(context);
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.settings),
              //   title: Text(AppTexts.settings),
              //   onTap: () {
              //     setState(() => selectedIndex = 1);
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        ),
        body: pages[selectedIndex],
        floatingActionButton: selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/note_edit');
                },
                tooltip: AppTexts.editNote,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.radius30),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
