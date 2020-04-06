import 'package:assistance_control_app/common/legal_document_decoder/error.dart';
import 'package:assistance_control_app/common/legal_document_decoder/fields.dart';
import 'package:dartz/dartz.dart';

import '../commons.dart';
import '../decoder.dart';

const Map<String, String> docTypeMap = {
  "CEDULA": "CEDULA_CHILENO",
  "CEDULA_EXT": "CEDULA_EXTRANJERO",
  "PASAPORTE_PG": "PASAPORTE_DIPLOMATICO",
  "PASAPORTE_OFICIAL": "PASAPORTE_OFICIAL",
};

class ChileDecoder implements LegalDocDecoder {
  static final String dateSeparator = "-";
  static final String chileRCHost =
      "https://portal.sidiv.registrocivil.cl/docstatus";
  static final String _rut2013 = "rut2013";
  static final String _rut2002 = "rut2002";

  static bool _isRut2013QrUrl(String data) {
    return data.startsWith(chileRCHost);
  }

  static bool _isRut2002PDF417(String data) {
    return data.contains("EABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghi");
  }

  static String _getDocumentType(String docType) {
    if (!docTypeMap.containsKey(docType)) {
      return docType;
    }
    return docTypeMap[docType];
  }

  static Map<String, String> _normalizeData(Map<String, String> data) {
    Map<String, String> newData = Map<String, String>();
    newData[CommonField.legalDoc.name] = data["RUN"];
    newData[CommonField.documentType.name] = _getDocumentType(data["type"]);
    if (newData[CommonField.documentType.name] != "CEDULA_CHILENO") {
      newData[CommonField.isForeign.name] = "true";
    }
    newData[CommonField.serial.name] = data["serial"];
    // To support variable serial length
    String cleanedMrz =
        data["mrz"].replaceFirst(data["serial"], "").substring(1);
    newData[CommonField.birthday.name] =
        _formatQrDate(cleanedMrz.substring(0, 6));
    newData[CommonField.expirationDate.name] =
        _formatQrDate(cleanedMrz.substring(7));
    return newData;
  }

  // format a qr date format to dd-MM-YYYY format.
  // i.e: "910523" -> "23-05-91"
  static String _formatQrDate(String qrDate) {
    int year = int.tryParse(qrDate.substring(0, 2));
    if (year == null){
      return "";
    }
    return "${qrDate.substring(4, 6)}$dateSeparator" +
        "${qrDate.substring(2, 4)}$dateSeparator" +
        "${_getCenturyOfYear(year)}${qrDate.substring(0, 2)}";
  }

  static int _getCenturyOfYear(int year) {
    int currentCentury =
        int.parse(DateTime.now().year.toString().substring(0, 2));
    int currentYear = int.parse(DateTime.now().year.toString().substring(2));
    if (currentYear > year) {
      return currentCentury;
    } else {
      return currentCentury - 1;
    }
  }

  @override
  DecoderResult decode(String data) {
    if (_isRut2013QrUrl(data)) {
      Tuple2<Map<String, String>, CustomError> ext =
          DecoderUtils.decodeFromQueryString(data);
      if (ext.value2 != null) {
        return DecoderResult.fromError(ext.value2);
      }
      Map<String, String> dataMap = ext.value1;
      dataMap = _normalizeData(dataMap);
      dataMap[CommonField.documentVersion.name] = _rut2013;
      return DecoderResult(null, dataMap);
    }
    if (_isRut2002PDF417(data)) {
      DecoderResult dataMap = _decodeRutPDF417(data);
      if (dataMap.errors != null){
        return dataMap;
      }
      dataMap.data[CommonField.documentVersion.name] = _rut2002;
      return dataMap;
    }
    return DecoderResult.fromError(CustomError("Unsuported document type",
        "UNS_DOC_TYPE", {"expected": "rutChile2013"}));
  }

  String removeInitialZeroes(String data){
    if (!data.startsWith("0")){
      return data;
    }
    int i = 0;
    for (; i<data.length; i++){
      if (data[i] != '0'){
        break;
      }
    }
    return data.substring(i-1);
  }

  DecoderResult _decodeRutPDF417(String data) {
    if (data.length < 419){
      return DecoderResult.fromError(CustomError("Unsuported document type",
          "UNS_DOC_TYPE", {"expected": "rutChile2013"})); 
    }
    String run = removeInitialZeroes(data.substring(0, 9).trim());
    String applicationNumber = data.substring(9, 19).trim();
    String lastName = data.substring(19, 49).trim().replaceAll("�", "").trim();
    String countryCode = data.substring(49, 52).trim();
    String dueDate = data.substring(52, 58).trim();
    String serial = data.substring(58, 68).trim();
    String disability = data.substring(68, 69).trim();
    String documentType = data.substring(69, 70).trim();
    String finger = data.substring(70, 74).trim();
    String long = data.substring(74, 78).trim();
    String fingerprint = data.substring(78).trim();
    Map<String, String> newData = {
      CommonField.legalDoc.name: run,
      "applicationNumber": applicationNumber,
      CommonField.lastName.name: lastName,
      CommonField.country.name: countryCode,
      CommonField.expirationDate.name: _formatQrDate(dueDate),
      CommonField.serial.name: serial,
      CommonField.disability.name: disability,
      CommonField.documentType.name: documentType,
      "finger": finger,
      "pc1Long": long,
      CommonField.fingerprint.name: fingerprint,
    };
    return DecoderResult(null, newData);
  }
}
