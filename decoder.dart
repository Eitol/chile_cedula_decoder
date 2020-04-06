import 'package:assistance_control_app/common/legal_document_decoder/country_code.dart';

import 'error.dart';

class DecoderResult {
  List<Error> errors;
  Map<String, String> data;
  DecoderResult(this.errors, this.data);

  static DecoderResult fromError(Error error){
    return DecoderResult([error], null);
  }
}

abstract class LegalDocDecoder {
  DecoderResult decode(String data);
}