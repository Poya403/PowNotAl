import 'package:flutter/material.dart';
import 'package:pow_note_ai/features/note/screens/note_list_screen.dart';
import 'package:pow_note_ai/utils/app_texts.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                  AppTexts.menu,
                  style: Theme.of(context).textTheme
                      .titleMedium?.copyWith(color: Colors.white)
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_outlined),
              title: Text(AppTexts.notes),
              onTap: () {
                Navigator.pushNamed(context, '/notes');
              },
            ),
          ],
        ),
      ),
      body: const NoteListScreen(),
    );
  }
}
