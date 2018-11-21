/*
 * Copyright (c) 2018, Marcin Marek Gocał
 * All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */

import 'package:intl/intl.dart';

//ignore_for_file: type_annotate_public_apis, non_constant_identifier_names
class S {
  /// contains title
  String get title =>
      Intl.message("Title", name: "title", desc: "contains title");

  /// contains message
  String get message =>
      Intl.message("Message", name: "message", desc: "contains message");

  /// contains app name
  String get app_name => Intl.message("Sample Application",
      name: "app_name", desc: "contains app name");

  /// contains login
  /// ggg
  /// gggg
  String get login =>
      Intl.message("Login", name: "login", desc: "contains login");

  /// contains registration
  String get register =>
      Intl.message("Register", name: "register", desc: "contains registration");

  ///
  String get placeholders =>
      Intl.message("null", name: "placeholders", desc: "");

  /// Single named argument
  String single_argument(String name) => Intl.message("Single {name} argument",
      name: "single_argument", args: [name], desc: "Single named argument");

  /// Two named arguments
  String two_arguments(String first, String second) =>
      Intl.message("Argument {first} and {second}",
          name: "two_arguments",
          args: [first, second],
          desc: "Two named arguments");
}
