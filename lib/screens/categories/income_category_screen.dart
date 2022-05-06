import 'package:flutter/material.dart';

class IncomeCategoryScreen extends StatefulWidget {
  const IncomeCategoryScreen({Key? key}) : super(key: key);

  @override
  State<IncomeCategoryScreen> createState() => _IncomeCategoryScreenState();
}

class _IncomeCategoryScreenState extends State<IncomeCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
                child: Row(children: [
              SizedBox(
                width: 15,
              ),
              Expanded(child: Text('Gaji Bulanan')),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit_outlined,
                      color: Colors.black.withOpacity(0.4))),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.delete_outline,
                      color: Colors.black.withOpacity(0.4))),
            ]));
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 0.7,
            );
          },
          itemCount: 10),
    );
  }
}
