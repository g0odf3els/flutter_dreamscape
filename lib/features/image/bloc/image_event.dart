part of 'image_bloc.dart';

class ImageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class ImageLoadRequested extends ImageEvent {
  final String id;
  ImageLoadRequested(this.id);
}
