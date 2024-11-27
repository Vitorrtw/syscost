abstract class UserState {}

class UserStateInitial extends UserState {}

class UserStateLoading extends UserState {}

class UserStateSuccess extends UserState {
  final String? message;

  UserStateSuccess([this.message]);
}

class UserStateError extends UserState {
  final String error;

  UserStateError(this.error);
}
