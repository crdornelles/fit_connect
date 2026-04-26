import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/deep_link_data.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final MethodChannel _methodChannel =
      const MethodChannel('com.fitconnect.app/deeplink');

  final EventChannel _eventChannel =
      const EventChannel('com.fitconnect.app/deeplink_stream');

  final StreamController<DeepLinkData> _controller =
      StreamController.broadcast();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _initialized = false;
  String? _initialLink;

  Stream<DeepLinkData> get deepLinkStream => _controller.stream;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Busca deep link inicial (app estava fechado)
    final String? initialUrl =
        await _methodChannel.invokeMethod('getInitialLink');

    _initialLink = initialUrl;

    if (initialUrl != null) {
      final data = _parseDeepLink(initialUrl);
      if (data != null) _controller.add(data);
    }

    // Stream para links quando app está aberto
    _eventChannel.receiveBroadcastStream().listen(
      (url) {
        if (url is String) {
          final data = _parseDeepLink(url);
          if (data != null) _controller.add(data);
        }
      },
      onError: (error) {
        // Log ou tratamento de erro
      },
      cancelOnError: false,
    );
  }

  // Deferred Deep Links — salva referralCode do cold start para uso posterior
  Future<void> processDeferredLink() async {
    if (_initialLink == null || !_initialLink!.contains('referralCode')) return;
    final uri = Uri.tryParse(_initialLink!);
    final code = uri?.queryParameters['referralCode'];
    if (code != null) {
      await _storage.write(key: 'pending_referral', value: code);
    }
  }

  // Recupera e limpa o referralCode pendente (usar na SignupScreen)
  Future<String?> getPendingReferralCode() async {
    final code = await _storage.read(key: 'pending_referral');
    if (code != null) {
      await _storage.delete(key: 'pending_referral');
      return code;
    }
    return null;
  }

  DeepLinkData? _parseDeepLink(String url) {
    try {
      final uri = Uri.parse(url);

      return DeepLinkData(
        url: url,
        type: _determineType(uri),
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: uri.queryParameters,
        referralCode: uri.queryParameters['referralCode'],
        receivedAt: DateTime.now(),
      );
    } catch (e) {
      return null;
    }
  }

  DeepLinkType _determineType(Uri uri) {
    if (uri.scheme == 'fitconnect') return DeepLinkType.customScheme;
    if (uri.scheme == 'https' && uri.host == 'deeplinkslab.dev') {
      return Platform.isIOS
          ? DeepLinkType.universalLink
          : DeepLinkType.appLink;
    }
    return DeepLinkType.unknown;
  }
}
