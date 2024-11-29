abstract class CutState {}

class CutStateInitial extends CutState {}

class CutStateLoading extends CutState {}

class CutStateSuccess extends CutState {
  final String? message;

  CutStateSuccess([this.message]);
}

class CutStateError extends CutState {
  final String error;

  CutStateError(this.error);
}
