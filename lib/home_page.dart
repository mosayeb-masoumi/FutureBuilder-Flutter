
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Future<int?> dataFuture;


  Future<int?> getData() async{

    final result = await http.get(Uri.parse( "https://www.randomnumberapi.com/api/v1.0/random"));
    await Future.delayed(Duration(seconds: 3));
    final body = json.decode(result.body);
    int randomNumber  = (body as List).first;
    // throw "Failed";
    return randomNumber;
    // return null;
  }


  @override
  void initState() {
    super.initState();

    dataFuture = getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<int?>(
          future: dataFuture,
          // initialData: 00,
          builder: (context , snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Text("waiting..." ,style: TextStyle(fontSize: 20),);

                //or show the last data until waiting
               // return snapshot.hasData?Text("${snapshot.data}" ,style: TextStyle(fontSize: 20),):
               // Text("waiting..." ,style: TextStyle(fontSize: 20),);

              case ConnectionState.done:
                default:
                  if(snapshot.hasError){
                    return Text("${snapshot.error}" ,style: TextStyle(fontSize: 20),);
                  }else if(snapshot.hasData){
                    return Text("${snapshot.data}" ,style: TextStyle(fontSize: 20),);
                  }else{
                    return Text("No Data" ,style: TextStyle(fontSize: 20),);
                  }
            }
          },
        )
      ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
          onPressed: (){
          setState(() {
            dataFuture = getData();
          });
          }),

    );

  }
}
