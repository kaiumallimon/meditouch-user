// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:crypto/crypto.dart';
//
// class AgoraTokenGenerator {
//   final String appId;
//   final String appCertificate;
//
//   AgoraTokenGenerator({
//     required this.appId,
//     required this.appCertificate,
//   });
//
//   /// Generate a temporary token
//   String generateToken({
//     required String channelName,
//     required int uid, // Use 0 for anonymous users
//     int expireTimeInSeconds = 3600, // Default expiration time: 1 hour
//   }) {
//     final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//     final expirationTime = currentTime + expireTimeInSeconds;
//
//     // Build raw token content
//     final content = {
//       'appId': appId,
//       'channelName': channelName,
//       'uid': uid.toString(),
//       'expireTimestamp': expirationTime.toString(),
//     };
//
//     // Generate the signature
//     final signature = _generateSignature(
//       appId,
//       appCertificate,
//       channelName,
//       uid,
//       expirationTime,
//     );
//
//     // Combine everything into the final token format
//     return base64Encode(utf8.encode(jsonEncode({
//       'signature': signature,
//       'content': content,
//     })));
//   }
//
//   /// Generate the HMAC-SHA256 signature
//   String _generateSignature(
//       String appId, String appCertificate, String channelName, int uid, int expireTime) {
//     final message = '$appId$channelName$uid$expireTime';
//     final key = utf8.encode(appCertificate);
//     final bytes = utf8.encode(message);
//
//     final hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
//     final digest = hmacSha256.convert(bytes);
//
//     return base64Encode(digest.bytes);
//   }
// }
