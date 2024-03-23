import 'package:vmerge/src/core/core.dart';

abstract interface class UseCase<T extends DataState<dynamic>, P> {
  const UseCase();

  Future<T> call({required P params});
}
