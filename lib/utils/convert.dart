class Convert {
  // ignore: non_constant_identifier_names
  static String hextoDecimal(String hex) {
    var id = "";
    if (hex != null && hex.isNotEmpty) {
      for (var i = 2; i < hex.length; i = i + 2) {
        id = hex.substring(i, i + 2) + id;
      }
      id = int.parse(id, radix: 16).toString();
    }
    return id;
  }
}
