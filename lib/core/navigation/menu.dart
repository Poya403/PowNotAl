import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/screens/note_list_screen.dart';
import 'package:pow_note_ai/features/note/screens/trash_screen.dart';
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
    //  const SettingsScreen(),
  ];

  final titles = [
    AppTexts.notes,
    AppTexts.trashList,
    //AppTexts.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(titles[selectedIndex])),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: Text(
                  AppTexts.menu,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.list_alt_outlined),
                title: Text(AppTexts.notes),
                onTap: () {
                  setState(() => selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.restore_from_trash_rounded),
                title: Text(AppTexts.trashList),
                onTap: () {
                  setState(() => selectedIndex = 1);
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
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radius30
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
