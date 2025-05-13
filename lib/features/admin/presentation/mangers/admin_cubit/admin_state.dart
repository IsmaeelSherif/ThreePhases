part of 'admin_cubit.dart';

sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminLoading extends AdminState {}

final class AdminLoaded extends AdminState {

}

final class AdminError extends AdminState {
  final String message;
  AdminError({required this.message});
}
final class AdminVerifyWordsSuccess extends AdminState {}
final class AdminVerifyWordsLoading extends AdminState {}
final class AdminVerifyWordsError extends AdminState {
  final String message;
  AdminVerifyWordsError({required this.message});
}
