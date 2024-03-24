import 'package:equatable/equatable.dart';
import 'package:vmerge/src/core/core.dart';

sealed class DataState<T> extends Equatable {
  const DataState({T? data, Failure? failure})
      : _data = data,
        _failure = failure;

  final T? _data;
  final Failure? _failure;

  @override
  List<Object?> get props => [_data, _failure];
}

final class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);

  T get data => _data!;
}

final class DataFailure<T> extends DataState<T> {
  const DataFailure(Failure failure) : super(failure: failure);

  String get message => _failure!.message;
  String get name => _failure!.name;
  Object get error => _failure!.error;
  StackTrace get stackTrace => _failure!.stackTrace;
}
