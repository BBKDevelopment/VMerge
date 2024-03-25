import 'package:vmerge/src/core/core.dart';

abstract interface class DataModel<T extends DomainEntity> {
  const DataModel();

  T toEntity();
}
