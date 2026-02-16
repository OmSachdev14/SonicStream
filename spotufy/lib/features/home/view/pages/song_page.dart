import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotufy/core/providers/current_song_notifier.dart';
import 'package:spotufy/core/theme/app_pallete.dart';
import 'package:spotufy/core/widgets/loader.dart';
import 'package:spotufy/core/widgets/utils.dart';
import 'package:spotufy/features/home/view/pages/upload_song.dart';
import 'package:spotufy/features/home/viewmodel/home_viewmodel.dart';

class SongPage extends ConsumerWidget {
  const SongPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedSongs =
        ref.watch(homeViewmodelProvider.notifier).getRecentlyPlayedSong();
    final currentSong = ref.watch(currentSongNotifierProvider);
    return AnimatedContainer(duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                  begin: AlignmentGeometry.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [
                  0.0,
                  0.3
                ],
                  colors: [
                  hexToColor(currentSong.hex_code),
                  Pallete.transparentColor
                ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 36),
            child: SizedBox(
              height: 240,
              child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                  itemCount: recentlyPlayedSongs.length,
                  itemBuilder: (context, index) {
                    final song = recentlyPlayedSongs[index];
                    return GestureDetector(
                      onTap: () {
                        ref
                            .read(currentSongNotifierProvider.notifier)
                            .updateSong(song);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Pallete.cardColor),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(song.thumbnail_url),
                                      fit: BoxFit.cover),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      bottomLeft: Radius.circular(4))),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                song.song_name,
                                style: const TextStyle(
                                    color: Pallete.whiteColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Latest Today',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadSong()));
                  },
                  icon: const Icon(Icons.upload)),
            ],
          ),
          ref.watch(getAllSongsProvider).when(
                data: (songs) {
                  return SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          // print(songs.length);
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          songs[index].thumbnail_url),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                      ));
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(error.toString()),
                  );
                },
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
