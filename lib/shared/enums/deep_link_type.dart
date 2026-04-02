enum DeepLinkType {
  customScheme,
  appLink, // Android HTTPS
  universalLink, // iOS HTTPS
  unknown;

  bool get isSecure => this == appLink || this == universalLink;
}
