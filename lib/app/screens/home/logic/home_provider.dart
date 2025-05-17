import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remember_me/app/api/api_service.dart';
import 'package:remember_me/app/screens/home/logic/home_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:remember_me/app/service/gcs_storage_service.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  build() {
    return HomeState();
  }

  final ImagePicker _picker = ImagePicker();

  void setTab(HomeTabs tab) {
    state = state.copyWith(selectedTab: tab);
  }

  Future<bool> saveRecording(String filePath) async {
    state = state.copyWith(recordedFilePath: filePath, isUploading: true);

    final result = await ApiService.I.uploadTextMemory(filePath);
    return result.fold(
      onSuccess: (data) {
        state = state.copyWith(isUploading: false);
        return data;
      },
      onFailure: (e) {
        state = state.copyWith(isUploading: false);
        return false;
      },
    );
  }

  Future<void> pickImage() async {
    state = state.copyWith(isUploading: true);
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var result = await GcsStorageService.I.uploadImageToGCS(File(image.path));
      if (!result.isSuccess) {
        state = state.copyWith(isUploading: true);
        return;
      }
      var serverResult = await ApiService.I.uploadImageMemory(
        File(image.path),
        result.data,
      );
      if (!serverResult.isSuccess) {
        state = state.copyWith(isUploading: true);
        return;
      }
      state = state.copyWith(isUploading: true);
    }
  }
}
