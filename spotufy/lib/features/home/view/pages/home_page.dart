import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotufy/core/providers/current_user_notifier.dart';
import 'package:spotufy/core/theme/app_pallete.dart';
import 'package:spotufy/features/home/view/pages/library_page.dart';
import 'package:spotufy/features/home/view/pages/song_page.dart';
import 'package:spotufy/features/home/view/widget/music_slab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final pages = const [SongPage(), LibraryPage()];
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final currentUser = ref.watch(currentUserNotifierProvider);
    // print(currentUser);
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(bottom: 0, child: MusicSlab())
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 0
                    ? 'assets/images/home_filled.png'
                    : 'assets/images/home_unfilled.png',
                color: selectedIndex == 0
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/library.png',
                color: selectedIndex == 1
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Library',
            ),
          ]),
    );
  }
}
