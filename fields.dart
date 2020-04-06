import 'package:enum_to_string/enum_to_string.dart';

enum CommonField{
  legalDoc,
  serial,
  firstName,
  middleName,
  lastName,
  motherName,
  birthday,
  expirationDate,
  issueDate,
  nationality,
  isForeign,
  documentVersion,
  documentType,
  country,
  disability,
  fingerprint,
}

extension CommonFieldExt on CommonField {
  String get name {
    return EnumToString.parse(this);
  }
}