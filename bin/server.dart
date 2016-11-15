import 'dart:async';
import 'dart:io';

import 'package:http_server/http_server.dart';

void main() {

  runZoned(() {
    HttpServer.bind('0.0.0.0', 8080).then((server) {
      server.listen((request) {
        request.response.headers..contentType = ContentType.TEXT;
        request.response
            ..writeln('Dart version: ${Platform.version}')
            ..writeln('Dart executable: ${Platform.executable}')
            ..writeln('Dart executable arguments: '
                      '${Platform.executableArguments}')
            ..close();
      });
    });
  },
  onError: (e, stackTrace) {
    print('Error processing request $e\n$stackTrace');
  });
}

