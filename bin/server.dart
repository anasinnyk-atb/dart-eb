import 'package:redstone/redstone.dart' as app;

@app.Route("/")
hello() => "HI REDSTONE";

main() {
  app.setupConsoleLog();
  app.start();
}

