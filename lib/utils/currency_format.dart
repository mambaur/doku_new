import 'package:intl/intl.dart';

/// Digunakan untuk merubah format angka ke dalam rupiah
/// Ex. 1000000 menjadi Rp. 1.000.000
/// currencyId.format(10000).toString(),
final currencyId =
    NumberFormat.currency(locale: 'ID', symbol: 'Rp ', decimalDigits: 0);

class CurrencyFormat {
  /// Mengubah concurrency format kedalam bentuk number
  /// Hanya dalam bentuk angka tanpa ada separator "." dan ","
  /// Dalam format Indonesia
  /// Return String
  static String toNumber(String number) {
    // Replace semua char setelah comma ","
    String noComma = (number).split(',')[0];
    noComma = noComma != '' ? noComma : '0';

    // Replace point "."
    String noPoint = noComma.split('.').join("");
    return noPoint;
  }
}
