import 'package:doku/screens/categories/income_category_screen.dart';
import 'package:doku/screens/transactions/create/expense_create_screen.dart';
import 'package:doku/screens/transactions/create/income_create_screen.dart';
import 'package:flutter/material.dart';

class OptionCreateScreen extends StatefulWidget {
  const OptionCreateScreen({ Key? key }) : super(key: key);

  @override
  State<OptionCreateScreen> createState() => _OptionCreateScreenState();
}

class _OptionCreateScreenState extends State<OptionCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder){
                      return IncomeCreateScreen();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_card, size: 170, color: Colors.grey.shade400,),
                        Text('Pemasukan', style: TextStyle(fontSize: 16),)
                      ],
                    )),
                ),
              ),
              // SizedBox(height: 10,),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder){
                      return ExpenseCreateScreen();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_atm, size: 170, color: Colors.grey.shade400,),
                        Text('Pengeluaran', style: TextStyle(fontSize: 16),)
                      ],
                    )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}