import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/deep_link_type.dart';

part 'deep_link_data.freezed.dart';

@freezed
class DeepLinkData with _$DeepLinkData {
  const factory DeepLinkData({
    required String url,
    required DeepLinkType type,
    required String scheme,
    String? host,
    String? path,
    @Default({}) Map<String, String> queryParameters,
    String? referralCode,
    required DateTime receivedAt,
  }) = _DeepLinkData;

  const DeepLinkData._();

  bool get isSignupLink => path == '/signup';
  bool get hasValidAffiliateCode =>
      referralCode != null && referralCode!.length == 20;
  bool get isValid => url.isNotEmpty;
  bool get isResetPasswordLink => path == '/reset-password';
  String? get token => queryParameters['token'];
}
