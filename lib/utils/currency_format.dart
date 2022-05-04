import 'package:intl/intl.dart';

/// Digunakan untuk merubah format angka ke dalam rupiah
/// Ex. 1000000 menjadi Rp. 1.000.000
/// currencyId.format(10000).toString(),
final currencyId =
    NumberFormat.currency(locale: 'ID', symbol: 'Rp ', decimalDigits: 0);