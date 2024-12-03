import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_bengkalis/screen/home.dart';
import 'package:project_bengkalis/screen/profile.dart';
import 'package:project_bengkalis/screen/transaction.dart';

import 'bloc/bloc/NavigationBloc.dart';
import 'bloc/event/NavigationEvent.dart';
import 'bloc/state/NavigationState.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  final List<Widget> _pages = const [
    HomePage(),
    TransactionPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
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
