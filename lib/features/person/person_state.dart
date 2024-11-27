abstract class PersonState {}

class PersonStateInitial extends PersonState {}

class PersonStateLoading extends PersonState {}

class PersonStateSuccess extends PersonState {
  final String? message;

  PersonStateSuccess([this.message]);
}

class PersonStateError extends PersonState {
  final String error;

  PersonStateError(this.error);
}
