abstract class EmbroideryState {}

class EmbroideryStateInitial extends EmbroideryState {}

class EmbroideryStateLoading extends EmbroideryState {}

class EmbroideryStateSuccess extends EmbroideryState {
  final String? message;

  EmbroideryStateSuccess([this.message]);
}

class EmbroideryStateError extends EmbroideryState {
  final String error;

  EmbroideryStateError(this.error);
}
