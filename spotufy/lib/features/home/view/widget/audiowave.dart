import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:spotufy/core/theme/app_pallete.dart';

class Audiowave extends StatefulWidget {
  final String path;
  const Audiowave({super.key, required this.path});

  @override
  State<Audiowave> createState() => _AudiowaveState();
}

class _AudiowaveState extends State<Audiowave> {
  final PlayerController playerController = PlayerController();
  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(
        path: widget.path, shouldExtractWaveform: true, noOfSamples: 50);
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer(forceRefresh: true);
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  Future<void> pauseAudio() async {
    await playerController.pausePlayer();
  }

  Future<void> stopAudio() async {
    await playerController.stopPlayer();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: playAndPause,
            icon: !playerController.playerState.isPlaying
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause)),
        Expanded(
          child: AudioFileWaveforms(
            size: const Size(double.infinity, 100),
            playerController: playerController,
            playerWaveStyle: const PlayerWaveStyle(
                fixedWaveColor: Pallete.borderColor,
                liveWaveColor: Pallete.gradient2,
                spacing: 5,
                showSeekLine: false),
          ),
        ),
      ],
    );
  }
}
