import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotufy/core/theme/app_pallete.dart';
import 'package:spotufy/core/widgets/custom_text_field.dart';
import 'package:spotufy/core/widgets/loader.dart';
import 'package:spotufy/core/widgets/utils.dart';
import 'package:spotufy/features/home/view/widget/audiowave.dart';
import 'package:spotufy/features/home/viewmodel/home_viewmodel.dart';

class UploadSong extends ConsumerStatefulWidget {
  const UploadSong({super.key});

  @override
  ConsumerState<UploadSong> createState() => _UploadSongState();
}

class _UploadSongState extends ConsumerState<UploadSong> {
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController songNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? selectedImage;
  File? selectedAudio;
  Color selectedColor = Pallete.cardColor;

  void selectAudio() async {
    final pickedFile = await pickAudio();
    if (pickedFile != null) {
      setState(() {
        // print('yes2');

        selectedAudio = pickedFile;
      });
    }
  }

  void selectImage() async {
    final pickedFile = await pickImage();
    // print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        // print('yes3');
        selectedImage = pickedFile;
      });
      // print(pickedFile.path);
    }
  }

  @override
  void dispose() {
    artistNameController.dispose();
    songNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeViewmodelProvider.select((val) => val?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Song"),
        actions: [
          IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedImage != null) {
                  ref.read(homeViewmodelProvider.notifier).uploadSong(
                      selectedAudio: selectedAudio!,
                      selectedImage: selectedImage!,
                      songName: songNameController.text,
                      artist: artistNameController.text,
                      selectedColor: selectedColor);
                } else {
                  showSnackBar(context, 'Missing fields');
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: isLoading ? const Loader() : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: selectImage,
                  child: selectedImage != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              )))
                      : DottedBorder(
                          color: Pallete.inactiveSeekColor,
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          strokeCap: StrokeCap.round,
                          dashPattern: const [10, 4],
                          child: const SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                Text(
                                  "Select the thumbnail for the song",
                                  style: TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                          )),
                ),
                const SizedBox(height: 40),
                selectedAudio != null
                    ? Audiowave(path: selectedAudio!.path)
                    : CustomField(
                        hintText: "Pick Song",
                        controller: null,
                        readOnly: true,
                        onTap: selectAudio,
                      ),
                const SizedBox(height: 20),
                CustomField(
                  hintText: "Artist Name",
                  controller: artistNameController,
                ),
                const SizedBox(height: 20),
                CustomField(
                  hintText: "Song Name",
                  controller: songNameController,
                ),
                const SizedBox(height: 40),
                ColorPicker(
                  pickersEnabled: const {
                    ColorPickerType.wheel: true,
                  },
                  color: selectedColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
