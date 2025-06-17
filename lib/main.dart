import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_bengkalis/data/models/movie_list.dart';
import 'package:project_bengkalis/di/injection.dart';
import 'package:project_bengkalis/presentation/blocs/movie_list/MovieListBloc.dart';
import 'package:project_bengkalis/presentation/screens/favorites.dart';
import 'package:project_bengkalis/presentation/screens/home.dart';
import 'package:project_bengkalis/presentation/screens/profile.dart';

import 'core/list_int_adapter.dart';
import 'data/services/MovieListService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ListIntAdapter());
  Hive.registerAdapter(MovieListAdapter());
  setupInjector();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovieListBloc(getIt<MovieListService>())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainMenu(),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  int currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(accountId: 123),
    SavedMovieScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
