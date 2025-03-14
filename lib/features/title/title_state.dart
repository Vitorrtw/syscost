abstract class TitleState {}

class TitleStateInitial extends TitleState {}

class TitleStateLoading extends TitleState {}

class TitleStateError extends TitleState {
  final String message;

  TitleStateError(this.message);
}

class TitleStateSuccess extends TitleState {
  final String message;

  TitleStateSuccess(this.message);
}
