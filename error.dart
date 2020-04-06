class CustomError extends Error{
  String msg;
  String code;
  Map<String, String> context;

  CustomError(this.msg, this.code, this.context);
}