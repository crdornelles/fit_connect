enum DeepLinkType { customScheme, appLink, universalLink, unknown }

class DeepLinkData {
  final String url;
  final DeepLinkType type;
  final String scheme;
  final String host;
  final String path;
  final Map<String, String> queryParameters;
  final String? referralCode;
  final DateTime receivedAt;

  const DeepLinkData({
    required this.url,
    required this.type,
    required this.scheme,
    required this.host,
    required this.path,
    required this.queryParameters,
    this.referralCode,
    required this.receivedAt,
  });
}
