import 'package:assistance_control_app/common/legal_document_decoder/fields.dart';
import 'package:test/test.dart';

import '../decoder.dart';
import 'chile.dart';
// Import the test package

final rutExtranjero = ChileDecoder.chileRCHost +
    "?RUN=26349413-K&type=CEDULA_EXT&serial=601498617&mrz=601498617891052301906257 ";

final rutNacional = ChileDecoder.chileRCHost +
    "?RUN=1916473-K&type=CEDULA&serial=516339654&mrz=516339654460121882312189";

final rut2002_1 = '''\
71334937 321640182 ALARCÃ.N.......................CHL230602010637148611.   Ã.   PC1{\C2? Ã U^EÂ¤a=Â.[9Ã¼SJÃ.]NÃ.iJÃ.d7z\0Â.\WDaZÃ.nSPkVÃ.P,Â.v>Ã.DTÃ.]aÃ.eaT>PÂ»lbÃ.9FÂµxYÃ.s`R?1Â.nkJ?eHM.Â.~iS;lÃ.~.m&DÂ©@xS YÂµ%dÃ.Â.oÃ..>Â hÂ.[&jFÂ¢>UÂ.vT.]Â¼.h=Â«5Ã.Â¨'`kÂ.iOÂ.eÂ.Â.eÂ.Â.[Â´3T(Â.]tÂ.oÂ¶RÃ.Â.Â.e.Â.RÂ.vM3Â.k~Â.w`Â¥wBÂ¢lÂ¾>VÂ.Â.cÂ¿GL5Â¤vÃ.BÃ.?EABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghij.
''';

final rut2002_2 = '''\
158531682321640182 MARTINEZ.......................CHL230602010182504811.   Ã.   PC1{\C2? Ã U^EÂ¤a=Â.[9Ã¼SJÃ.]NÃ.iJÃ.d7z\0Â.\WDaZÃ.nSPkVÃ.P,Â.v>Ã.DTÃ.]aÃ.eaT>PÂ»lbÃ.9FÂµxYÃ.s`R?1Â.nkJ?eHM.Â.~iS;lÃ.~.m&DÂ©@xS YÂµ%dÃ.Â.oÃ..>Â hÂ.[&jFÂ¢>UÂ.vT.]Â¼.h=Â«5Ã.Â¨'`kÂ.iOÂ.eÂ.Â.eÂ.Â.[Â´3T(Â.]tÂ.oÂ¶RÃ.Â.Â.e.Â.RÂ.vM3Â.k~Â.w`Â¥wBÂ¢lÂ¾>VÂ.Â.cÂ¿GL5Â¤vÃ.BÃ.?EABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghij
''';

void testRutExtranjero() {
  // Define the test
  test("testRutExtranjero", () {
    // Arrange
    DecoderResult expected = DecoderResult(null, {
      CommonField.legalDoc.name: "26349413-K",
      CommonField.documentType.name: "CEDULA_EXTRANJERO",
      CommonField.serial.name: "601498617",
      CommonField.birthday.name: "23-05-91",
      CommonField.expirationDate.name: "25-06-19",
    });

    // Act
    DecoderResult actual = ChileDecoder().decode(rutExtranjero);

    // Asset
    expect(actual.data[CommonField.legalDoc.name],
        expected.data[CommonField.legalDoc.name]);
    expect(actual.data[CommonField.documentType.name],
        expected.data[CommonField.documentType.name]);
    expect(actual.data[CommonField.serial.name],
        expected.data[CommonField.serial.name]);
    expect(actual.data[CommonField.birthday.name],
        expected.data[CommonField.birthday.name]);
    expect(actual.data[CommonField.expirationDate.name],
        expected.data[CommonField.expirationDate.name]);
  });
}

void testRutNacional() {
  // Define the test
  test("testRutNacional", () {
    // Arrange
    DecoderResult expected = DecoderResult(null, {
      CommonField.legalDoc.name: "1916473-K",
      CommonField.documentType.name: "CEDULA_CHILENO",
      CommonField.serial.name: "516339654",
      CommonField.birthday.name: "18-12-60",
      CommonField.expirationDate.name: "18-12-23",
    });

    // Act
    DecoderResult actual = ChileDecoder().decode(rutNacional);

    // Asset
    expect(actual.data[CommonField.legalDoc.name],
        expected.data[CommonField.legalDoc.name]);
    expect(actual.data[CommonField.documentType.name],
        expected.data[CommonField.documentType.name]);
    expect(actual.data[CommonField.serial.name],
        expected.data[CommonField.serial.name]);
    expect(actual.data[CommonField.birthday.name],
        expected.data[CommonField.birthday.name]);
    expect(actual.data[CommonField.expirationDate.name],
        expected.data[CommonField.expirationDate.name]);
  });
}

void main() {
  testRutExtranjero();
  testRutNacional();
}
