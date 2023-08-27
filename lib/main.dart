import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tests/app.dart';
import 'package:firebase_tests/firebase_options.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
