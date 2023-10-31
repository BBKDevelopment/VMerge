// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

abstract class LauncerService {
  Future<void> sendMail();
  Future<void> launchUrl(String url);
}
