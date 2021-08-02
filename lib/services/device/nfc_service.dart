import 'dart:async';

import 'package:nfc_io/nfc_io.dart';

class NfcService {
  static StreamSubscription subscription;
  static start(Function onRead) {
    stop();
    subscription = NfcIo.startReading.listen(onRead);
  }

  static stop() async {
    if (isStarting) {
      subscription.cancel();
      subscription = null;
      await NfcIo.stopReading;
    }
  }

  static get isStarting {
    return subscription != null;
  }
}
