import 'package:flutter/material.dart';

class ExpenseCategoryScreen extends StatefulWidget {
  const ExpenseCategoryScreen({ Key? key }) : super(key: key);

  @override
  State<ExpenseCategoryScreen> createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index){
        return Container(
          child: Row(
            children: [
              SizedBox(width: 15,),
              Expanded(
                child: Text('Biaya Hidup')
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.black.withOpacity(0.8))),
              IconButton(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.black.withOpacity(0.8))),
            ]
          )
        );
      }, separatorBuilder: (context, index){
        return Divider(
          height: 1,
          thickness: 0.7,
        );
      }, itemCount: 10),
    );
  }
}