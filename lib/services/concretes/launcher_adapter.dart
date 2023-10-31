// Copyright 2021 BBK Development. All rights reserved.
// Use of this source code is governed by a GPL-style license that can be found
// in the LICENSE file.

import 'package:url_launcher/url_launcher.dart';
import 'package:vmerge/services/abstracts/launcer_service.dart';

class LauncherAdapter extends LauncerService {
  LauncherAdapter() {
    emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@bbkdevelopment.com',
      queryParameters: {'subject': 'VMerge'},
    );
  }
  late final Uri emailLaunchUri;

  @override
  Future<void> sendMail() async {
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  @override
  Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
