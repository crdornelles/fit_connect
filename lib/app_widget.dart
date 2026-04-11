import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'models/deep_link_data.dart';
import 'services/deep_link_service.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  StreamSubscription<DeepLinkData>? _deepLinkSub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    final service = DeepLinkService();

    // Listener registrado antes de initialize() para não perder
    // o evento de cold start emitido durante a inicialização
    _deepLinkSub = service.deepLinkStream.listen((data) {
      if (data.path == '/signup' && data.referralCode != null) {
        _handleSignupLink(data);
      }
    });

    await service.initialize();
  }

  void _handleSignupLink(DeepLinkData data) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.to.navigate('/signup', arguments: data);
    });
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF667EEA)),
        useMaterial3: true,
      ),
      routerConfig: Modular.routerConfig,
    );
  }
}
