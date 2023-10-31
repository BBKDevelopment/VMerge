// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

class MoreItem {
  MoreItem(this._iconPath, this._title);
  final String _iconPath;
  final String _title;

  String get title => _title;
  String get iconPath => _iconPath;
}
