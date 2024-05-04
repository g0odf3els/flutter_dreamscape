part of 'upload_bloc.dart';

class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

final class UploadNewImageRequest extends UploadEvent {
  final File file;
  final String accessToken;

  const UploadNewImageRequest({required this.file, required this.accessToken});
}

final class DeleteImageRequest extends UploadEvent {
  final String fileId;
  final String accessToken;

  const DeleteImageRequest({required this.fileId, required this.accessToken});
}
