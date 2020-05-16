import 'dart:convert';

import 'package:flutter/material.dart';
import 'CCData.dart';
import 'package:http/http.dart' as http;

    class CCList extends StatefulWidget{
        @override
        State<StatefulWidget> createState() {
          return CCListState();
       }
    }

    class CCListState extends State<CCList>{
      List<CCData> data = [];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
            appBar: AppBar(
              title: Text('Awesome CC Traker'),
            ),
            body: Container(
                child: ListView(
                  children: _buildList(),
                )
            ),
            floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
              onPressed: () => _loadCC(),
            ),
      );
    }

    _loadCC() async {
    final response = await http.get('https://api.coincap.io/v2/assets?limit=10');
    if (response.statusCode == 200){
      var allData = (json.decode(response.body) as Map)['data'];
      var ccDataList = List<CCData>();
      allData.forEach((val){
        var record = CCData(
            name: val['name'],
            symbol: val['symbol'],
            price: double.parse(val['priceUsd']),
            rank: int.parse(val['rank'])
        );
        ccDataList.add(record);
      });
      setState(() {
        data = ccDataList;
      });
    }
    }

    List<Widget> _buildList(){
      return data.map((CCData f) => ListTile(
        subtitle: Text(f.symbol),
        title: Text(f.name),
        leading: CircleAvatar(child: Text(f.rank.toString())),
        trailing: Text('\$${f.price.toStringAsFixed(2)}'),
      )).toList();
    }

    @override
    void initState(){
      super.initState();
      _loadCC();
    }
  }

