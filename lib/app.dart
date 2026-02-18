import 'package:flutter/material.dart';
import 'package:pow_note_ai/core/navigation/menu.dart';
import 'package:pow_note_ai/features/backup_panel/providers/back_up_provider.dart';
import 'package:pow_note_ai/features/backup_panel/screens/back_up_screen.dart';
import 'package:pow_note_ai/features/note/screens/note_list_screen.dart';
import 'package:pow_note_ai/features/note/screens/note_edit_screen.dart';
import 'package:pow_note_ai/features/trash_panel/screens/trash_screen.dart';
import 'package:provider/provider.dart';
import 'package:pow_note_ai/features/note/providers/note_provider.dart';
import 'package:pow_note_ai/features/note/screens/note_detail_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NoteProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => BackUpProvider()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flutter demo',

        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'FarsiFonts',

          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurpleAccent,
              surfaceContainerHighest: Colors.white
          ),

          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 13),
            bodyMedium: TextStyle(fontSize: 16),
            bodyLarge: TextStyle(fontSize: 18),
            titleSmall: TextStyle(fontSize: 20),
            titleMedium: TextStyle(fontSize: 25),
            titleLarge: TextStyle(fontSize: 35),
          ),
        ),


        darkTheme: ThemeData(
          colorScheme:  ColorScheme.dark(
            primary: Colors.deepPurpleAccent,
              secondary: Colors.deepPurpleAccent,
              surface: Color(0xFF1E1E1E),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: Colors.white,
              surfaceContainerHighest: Colors.grey[800],
              error: Colors.redAccent,
              onError: Colors.white,
          ),
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey,
          ),
          fontFamily: 'FarsiFonts',
          textTheme: const TextTheme(
            bodySmall: TextStyle(fontSize: 15),
            bodyMedium: TextStyle(fontSize: 16),
            bodyLarge: TextStyle(fontSize: 18),
            titleSmall: TextStyle(fontSize: 20),
            titleMedium: TextStyle(fontSize: 25),
            titleLarge: TextStyle(fontSize: 35),
          ),
          primaryColor: Colors.deepPurpleAccent
        ),

        themeMode: ThemeMode.system,

        initialRoute: '/',
        home: MenuScreen(),
        routes: {
          '/notes': (context) => const NoteListScreen(),
          '/trash_list': (context) => const TrashScreen(),
          '/backup': (context) => const BackUpScreen(),
          '/note_edit': (context) => const NoteEditScreen(),
          '/note_view': (context) => const NoteDetailScreen(),
        },
      ),
    );
  }
}
