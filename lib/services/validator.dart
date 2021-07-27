class Validator {
  static String isimKontrol(String value) {
    if (value.length == 0)
      return "Lütfen Oyuncu adını giriniz";
    else if (value.contains("-") || value.contains("é") || value.contains(","))
      return "Oyuncu adı '-', 'é' veya ',' içeremez";
    return null;
  }
}
