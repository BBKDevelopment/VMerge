import 'package:equatable/equatable.dart';

final class Failure extends Equatable {
  const Failure({
    required this.exception,
    required this.message,
    required this.stackTrace,
  });

  final Object exception;
  final String message;
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [exception, message, stackTrace];
}
