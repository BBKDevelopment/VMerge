// Copyright 2024 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'dart:collection';

import 'package:equatable/equatable.dart';

/// {@template limited_list}
/// A limited list that can only contain a certain number of items. When a new
/// item is added and the list is full, the oldest item is removed.
/// {@endtemplate}
final class LimitedList<T> extends Equatable with ListBase<T> {
  /// {@macro limited_list}
  LimitedList({required this.maxLength}) : _items = [];

  /// The maximum number of items that the list can contain.
  final int maxLength;

  /// The internal list that contains the items.
  final List<T> _items;

  /// The number of items in the list.
  @override
  int get length => _items.length;

  /// Assigns a new length to the list. The new length must not exceed the
  /// current length.
  ///
  /// Throws a [RangeError] if the new length exceeds [maxLength].
  @override
  set length(int newLength) {
    if (newLength > maxLength) {
      throw RangeError('New length exceeds maxLength');
    }
    _items.length = newLength;
  }

  /// Adds an item to the list. If the list is full, the oldest item is removed.
  /// Returns the removed item if the list is full, otherwise returns `null`.
  @override
  T? add(T item) {
    _items.add(item);
    if (_items.length > maxLength) {
      return _items.removeAt(0);
    }
    return null;
  }

  /// Throws an [UnsupportedError] because [LimitedList] does not support adding
  /// multiple items at once.
  @override
  void addAll(Iterable<T> iterable) {
    throw UnsupportedError('LimitedList does not support addAll');
  }

  /// Returns the item at the given [index].
  @override
  T operator [](int index) => _items[index];

  /// Sets the item at the given [index] to the given [value].
  @override
  void operator []=(int index, T value) {
    _items[index] = value;
  }

  @override
  List<Object?> get props => [
        maxLength,
        _items,
      ];
}
