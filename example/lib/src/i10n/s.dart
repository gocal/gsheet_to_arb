import 'package:intl/intl.dart';

//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names
class S {
  /// contains title
  get common_title =>
      Intl.message("Title", name: "common_title", desc: "contains title");

  /// contains message
  get common_message =>
      Intl.message("Message", name: "common_message", desc: "contains message");

  /// contains app name
  get common_app_name => Intl.message("Sample Application",
      name: "common_app_name", desc: "contains app name");

  /// contains login
  get login_login =>
      Intl.message("Login", name: "login_login", desc: "contains login");

  ///
  get signup_register =>
      Intl.message("Register", name: "signup_register", desc: "");
}
