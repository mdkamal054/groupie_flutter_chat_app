import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
       backgroundColor: Theme.of(context).primaryColor,
       elevation: 0,
       title:const Text("Profile",
       style: TextStyle(
         fontSize: 27,
         color: Colors.white
       ),),
     ),
    );
  }
}
