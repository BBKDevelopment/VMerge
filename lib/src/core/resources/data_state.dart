import 'package:equatable/equatable.dart';
import 'package:vmerge/src/core/core.dart';

sealed class DataState<T> extends Equatable {
  const DataState({this.data, this.failure});

  final T? data;
  final Failure? failure;

  @override
  List<Object?> get props => [data, failure];
}

final class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

final class DataFailure<T> extends DataState<T> {
  const DataFailure(Failure failure) : super(failure: failure);
}
