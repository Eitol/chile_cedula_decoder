import 'package:assistance_control_app/common/legal_document_decoder/error.dart';
import 'package:dartz/dartz.dart';




class DecoderUtils {
  static Tuple2<Map<String, String>, CustomError> decodeFromQueryString(
      String url) {
    if (!url.contains("\?")) {
      return Tuple2(
        null,
        CustomError(
            "missing '?' separator in url", "INV_URL_MISSING_Q", {"url": url}),
      );
    }
    url = url.substring(url.indexOf("\?") + 1);
    return Tuple2(Uri.splitQueryString(url), null);
  }
}
