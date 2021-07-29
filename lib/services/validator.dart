class Validator {
  static String isimKontrol(String value) {
    if (value.length == 0)
      return "Lütfen Oyuncu adını giriniz";
    else if (value.contains("-") || value.contains("é") || value.contains(","))
      return "Oyuncu adı '-', 'é' veya ',' içeremez";
    return null;
  }

  static String degerKontrol(String value) {
    if (value == null || value.length == 0) {
      return "Lütfen bir para girin";
    } else if (value.contains(",") || value.contains(".")) {
      return "Lütfen tam sayı giriniz";
    }
    return null;
  }
}
