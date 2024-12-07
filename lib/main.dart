import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bengkalis/di/injection.dart';
import 'package:project_bengkalis/presentation/blocs/bloc/MovieListBloc.dart';
import 'package:project_bengkalis/presentation/blocs/bloc/NavigationBloc.dart';
import 'package:project_bengkalis/presentation/blocs/event/MovieListEvent.dart';
import 'package:project_bengkalis/presentation/blocs/event/NavigationEvent.dart';
import 'package:project_bengkalis/presentation/blocs/state/NavigationState.dart';
import 'package:project_bengkalis/presentation/screens/home.dart';
import 'package:project_bengkalis/presentation/screens/profile.dart';
import 'package:project_bengkalis/presentation/screens/transaction.dart';

import 'data/services/MovieListService.dart';

void main() {
  setupInjector();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        navigatorObservers: [ChuckerFlutter.navigatorObserver],
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  final List<Widget> _pages = const [
    HomePage(accountId: 123),
    TransactionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (_) => MovieListBloc(getIt<MovieListService>())..add(FetchMovieListsEvent())),
      ],
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;

          if (state is NavigationTabSelected) {
            currentIndex = state.tabIndex;
          }

          return Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<NavigationBloc>().add(NavigationTabChanged(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.swap_horiz),
                  label: 'Transaksi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}