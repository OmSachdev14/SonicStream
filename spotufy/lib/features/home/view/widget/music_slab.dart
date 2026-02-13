import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotufy/core/providers/current_song_notifier.dart';
import 'package:spotufy/core/theme/app_pallete.dart';
import 'package:spotufy/features/home/view/widget/music_player.dart';
import 'package:spotufy/core/widgets/utils.dart';
import 'package:spotufy/features/home/viewmodel/home_viewmodel.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    if (currentSong == null) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return const MusicPlayer();
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.easeIn));
                final offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ));
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                color: hexToColor(currentSong.hex_code),
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width - 16,
            height: 66,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'music-image',
                        child: Container(
                          width: 48,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image:
                                      NetworkImage(currentSong.thumbnail_url),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async{
                            await ref
                                .read(homeViewmodelProvider.notifier)
                                .favSong(songId: currentSong.id);
                          },
                          icon: const Icon(
                            Icons.favorite_border_outlined,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            songNotifier.playPause();
                          },
                          icon: Icon(
                            songNotifier.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Pallete.whiteColor,
                            size: 35,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer?.positionStream,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  const SizedBox();
                }
                final position = asyncSnapshot.data;
                final duration = songNotifier.audioPlayer!.duration;
                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                return Positioned(
                  bottom: 0,
                  left: 8,
                  child: Container(
                    height: 2,
                    width:
                        sliderValue * (MediaQuery.of(context).size.width - 32),
                    decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.circular(100)),
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                  color: Pallete.inactiveSeekColor,
                  borderRadius: BorderRadius.circular(100)),
            ),
          )
        ],
      ),
    );
  }
}
