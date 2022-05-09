import 'package:doku/database/categories/category_repository.dart';
import 'package:doku/models/category_model.dart';
import 'package:flutter/material.dart';

class IncomeCreateScreen extends StatefulWidget {
  const IncomeCreateScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCreateScreen> createState() => _IncomeCreateScreenState();
}

class _IncomeCreateScreenState extends State<IncomeCreateScreen> {
  DateTime now = DateTime.now();
  DateTime dateTransaction = DateTime.now();
  List<CategoryModel> listCategories = [];
  CategoryModel selectedCategory = CategoryModel();
  final CategoryRepository _categoryRepo = CategoryRepository();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Future<DateTime?> _selectDate(DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.red.shade600,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
        initialDate: initialDate,
        firstDate: DateTime((now.year - 100), 8),
        lastDate: DateTime(now.year + 1));
    return picked;
  }

  Future getCategory() async {
    List<CategoryModel>? data = await _categoryRepo.all(type: 'income');

    if (data.isNotEmpty) {
      selectedCategory = data[0];
      setState(() {
        listCategories = data;
      });
    }
  }

  @override
  void initState() {
    _nominalController.text = '0';
    String dateNow =
        '${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString()}';
    _dateController.text = dateNow;
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pemasukan'),
        elevation: 0.5,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await _selectDate(dateTransaction);
                    if (picked != null && picked != dateTransaction) {
                      setState(() {
                        dateTransaction = picked;
                        _dateController.text =
                            dateTransaction.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextField(
                      controller: _dateController,
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        labelText: 'Tanggal',
                        suffixIcon: Icon(Icons.date_range),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: TextField(
                    controller: _nominalController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      labelText: 'Jumlah Uang',
                      suffixIcon: Icon(Icons.credit_card),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: DropdownButton<CategoryModel>(
                    itemHeight: 70.0,
                    value: selectedCategory,
                    icon: const Icon(Icons.arrow_drop_down),
                    elevation: 2,
                    isExpanded: true,
                    style: TextStyle(color: Colors.green.shade400),
                    underline: Container(
                      height: 2,
                      color: Colors.green.shade400,
                    ),
                    onChanged: (CategoryModel? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: listCategories.map<DropdownMenuItem<CategoryModel>>(
                        (CategoryModel value) {
                      return DropdownMenuItem<CategoryModel>(
                        value: value,
                        child: Text(
                          value.name ?? '',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  color: Colors.grey.shade100,
                  margin: EdgeInsets.only(bottom: 3),
                  child: TextField(
                    controller: _notesController,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.top,
                    // expands: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        hintText: 'Keterangan'),
                  ),
                ),
              ],
            ),
          ),
          Container(
              // width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(primary: Colors.green.shade400),
                  onPressed: () {},
                  child: Text('TAMBAH',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ))
        ],
      ),
    );
  }
}
