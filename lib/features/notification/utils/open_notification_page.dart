import 'package:flutter/material.dart';

import '../pages/notification_page.dart';

void openNotificationPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => const NotificationPage()));
}
