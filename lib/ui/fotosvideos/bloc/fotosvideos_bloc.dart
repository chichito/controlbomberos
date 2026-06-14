import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'fotosvideos_event.dart';
part 'fotosvideos_state.dart';

class FotosvideosBloc extends Bloc<FotosvideosEvent, FotosvideosState> {
  final ImagePicker _picker = ImagePicker();

  FotosvideosBloc() : super(FotosvideosState(images: [])) {
    on<PickImagesFromCameraEvent>(_pickImagesFromCameraEvent);
    on<PickImagesFromGalleryEvent>(_pickImagesFromGalleryEvent);
    on<ClearImagesEvent>(_clearImagesEvent);
  }

  Future<void> _pickImagesFromCameraEvent(
    PickImagesFromCameraEvent event,
    Emitter<FotosvideosState> emit,
  ) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      emit(state.copyWith(images: [...state.images, photo]));
    }
  }

  Future<void> _pickImagesFromGalleryEvent(
    PickImagesFromGalleryEvent event,
    Emitter<FotosvideosState> emit,
  ) async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      emit(state.copyWith(images: [...state.images, ...selectedImages]));
    }
  }

  FutureOr<void> _clearImagesEvent(
    ClearImagesEvent event,
    Emitter<FotosvideosState> emit,
  ) {}
}
