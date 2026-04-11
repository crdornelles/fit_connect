import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app_widget.dart';
import 'modules/auth/pages/signup_page.dart';
import 'modules/home/pages/home_page.dart';

void main() {
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

class AppModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (_) => const HomePage());
    r.child('/signup', child: (_) => const SignupPage());
  }
}
