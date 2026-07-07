class Constants {
  // TODO(PRODUCTION): The Paymob merchant API key must NOT live in the client.
  // It is base64-decodable to a Merchant JWT and is extractable from the shipped
  // APK/IPA, letting anyone mint auth tokens and create orders as the merchant.
  // Before production: move this key to a backend, expose an endpoint that returns
  // a short-lived payment key, and have the app call that endpoint instead of
  // talking to accept.paymob.com directly. Kept here only so the demo keeps working.
  static const String apiKey = "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRFMU1qWXpNQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5DS0Q1SDlidkpuZHJEdGg5OEVFUmd2bUp6S2xTODFtc2lCZDRFTzUwcUVmWEV0X2lwc252UzgzQ1VOLW54bHRLQ2hHaklfNjNDVy1acHpfQ0E1Z1R4Zw==";
  static const int integrationIdCard = 5612956;
  static const int integrationIdWallet = 5613099;
  static const int iframeId = 1032146;
}
