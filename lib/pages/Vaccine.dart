import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pa3/pages/LoginComplete.dart';
import 'package:pa3/pages/StartLive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


Future<List<Country>> fetchCountry(http.Client client) async{
  String url = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json';
  await Future.delayed(Duration(seconds: 5));
  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json'));
  //print(response.body);
  return compute(parseCountry, response.body);
}
List<Country> parseCountry(String responseBody){
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Country>((json)=>Country.fromJson(json)).toList();
}

class Country{
  final String country;
  final String iso_code;
  final dynamic data;
  // final String total_vaccinations;

  Country({
    @required this.country, @required this.iso_code, @required this.data});
  factory Country.fromJson(Map<String, dynamic>json){
    return Country(
      country: json['country'] as String,
      iso_code: json['iso_code'] as String,
      data: json['data'] as dynamic,
    );
  }
}

class Vaccine extends StatelessWidget {
  TextEditingController usrid;
  final String page = "Vaccine Page";
  List<FlSpot> spotData = [];
  List<FlSpot> graph1 = [];
  List<FlSpot> graph2 = [];
  List<FlSpot> graph3 = [];
  List<FlSpot> graph4 = [];
  List<String> TableData0=[];
  List<String> TableData1=[];
  List<String> TableData2=[];
  double interv;

  Vaccine({Key key, @required this.usrid}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 350,
                  height: 110,
                  decoration: BoxDecoration(
                    shape:BoxShape.rectangle,
                    borderRadius:BorderRadius.circular(10.0),
                    border: Border.all(
                        color:Colors.black38,
                        width:3
                    ),
                  ),
                  child:
                  FutureBuilder<List<Country>>(
                    future:fetchCountry(http.Client()),
                    builder:(context, snapshot){
                      if(snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? Center(child:CountryList(country : snapshot.data))
                          :Center(child:CircularProgressIndicator());
                    },

                  )
              ),
              Container(
                  margin: EdgeInsets.only(top:15.0) ,
                  width: 350,
                  height: 250,
                  decoration: BoxDecoration(
                    shape:BoxShape.rectangle,
                    borderRadius:BorderRadius.circular(10.0),
                    border: Border.all(
                        color:Colors.black38,
                        width:3
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              // width: 60.0,
                              height: 35.0,
                              child:Text("Graph1",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              spotData.clear();
                              spotData = graph1;
                              interv=200000000;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.0,
                              child: Text("Graph2",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              spotData.clear();
                              spotData = graph2;
                              interv=4000000;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.0,
                              child: Text("Graph3",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              spotData.clear();
                              spotData = graph3;
                              interv=1000000000;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35.0,
                              child: Text("Graph4",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              spotData.clear();
                              spotData = graph4;
                              interv=20000000;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color:Colors.grey,
                        thickness: 3,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Container(
                              alignment: Alignment.center,
                              width: 320,
                              height: 180,
                              padding: EdgeInsets.all(5.0),
                              child:
                              FutureBuilder<List<Country>>(
                                future:fetchCountry(http.Client()),
                                builder:(context, snapshot){
                                  if(snapshot.hasError) print(snapshot.error);
                                  else if(snapshot.hasData){
                                    graph1=CountryList(country : snapshot.data).makegraph1();
                                    graph2=CountryList(country : snapshot.data).makegraph2();
                                    graph3=CountryList(country : snapshot.data).makegraph3();
                                    graph4=CountryList(country : snapshot.data).makegraph4();
                                    if(spotData.length==0) {
                                      spotData = graph1;
                                      interv=200000000;
                                    }
                                  }
                                  return snapshot.hasData
                                      ? Center(child:Graphs(spotData:spotData,country: snapshot.data, interv:interv))
                                      :Center(child:CircularProgressIndicator());
                                },

                              )
                          )
                      ),
                    ],
                  )
              ),
              Container(
                  margin: EdgeInsets.only(top:15.0) ,
                  width: 350,
                  height: 240,
                  decoration: BoxDecoration(
                    shape:BoxShape.rectangle,
                    borderRadius:BorderRadius.circular(10.0),
                    border: Border.all(
                        color:Colors.black38,
                        width:3
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 35.0,
                              child: Text("Country_name",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              TableData0.clear();
                              TableData0=TableData1;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 30.0,
                              child: Text("Total_vacc",
                                style: TextStyle(color:Colors.blue, fontWeight: FontWeight.bold),),
                            ),
                            onTap: (){
                              TableData0.clear();
                              TableData0=TableData2;
                              (context as Element).markNeedsBuild();
                            },
                          ),
                        ],
                      ),
                      Divider(
                        color:Colors.grey,
                        thickness: 3,
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 320,
                          height: 180,
                          child:
                          FutureBuilder<List<Country>>(
                            future:fetchCountry(http.Client()),
                            builder:(context, snapshot){
                              if(snapshot.hasError) print(snapshot.error);
                              if(snapshot.hasData){
                                TableData1=CountryTable(country: snapshot.data,).makeTable1();
                                TableData2=CountryTable(country: snapshot.data,).makeTable2();
                              }
                              return snapshot.hasData
                                  ? Center(child:CountryTable(country: snapshot.data, TableData: TableData0,))
                                  :Center(child:CircularProgressIndicator());
                            },

                          )
                      )
                    ],
                  )
              ),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder:(context)=>StartLive(usrid: usrid,page: page)),
          );
        },
        child:Icon(Icons.list),
      ),
    );
  }
}

class Graphs extends StatelessWidget{
  List<FlSpot> spotData;
  List<Country> country;
  List<String> dateData;
  double interv;
  Graphs({Key key, this.spotData,this.country, this.interv}):super(key: key);

  List<String> dateList(){
    List<String> dateData=[];
    int korea_index;
    for(int i=0;i<country.length;i++){
      if(country[i].country == 'South Korea'){
        korea_index = i;
        break;
      }
    }
    if(spotData.length==7) {
      for (int i = 0; i < 7; i++)
        dateData.add(
            country[korea_index].data[country[korea_index].data.length - 1 - i]['date'].toString().substring(5));
    }
    else {
      for (int i = 0; i < 7; i++)
        dateData.add(country[korea_index].data[country[korea_index].data.length - 1-7*i ]['date'].toString().substring(5));
    }
    return dateData;
  }
  @override
  Widget build(BuildContext context){
    return LineChart(LineChartData(
        borderData:FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
              colors:[Colors.blueAccent],
              dotData:FlDotData(show:true),
              spots:spotData
          )
        ],
        titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles:(value){
                switch(value.toInt()){
                  case 0:
                    return dateList()[6];
                  case 1:
                    return dateList()[5];
                  case 2:
                    return dateList()[4];
                  case 3:
                    return dateList()[3];
                  case 4:
                    return dateList()[2];
                  case 5:
                    return dateList()[1];
                  case 6:
                    return dateList()[0];
                }
                return '';
              },
              margin:6,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              margin:6,
              interval:interv,
            )
        )
    )
    );
  }
}
class CountryTable extends StatelessWidget{
  final List<Country> country;
  CountryTable({Key key, this.country, this.TableData}):super(key: key);
  List<String> TableData;

  List<String> makeTable1(){
    String parsedrecentdate;
    List<String> table1=[];
    table1.add("Country");
    table1.add("total");
    table1.add("fully");
    table1.add("daily");
    int k;
    for(int i=0;i<country.length;i++){
      if(country[i].country == 'South Korea'){
        k = i;
        break;
      }
    }
    parsedrecentdate=country[k].data[country[k].data.length-1]['date'].toString();
    int recent;
    for(int i=0;i<7;i++) {
      recent = -1;
      for (int j = country[i].data.length - 1; j >= 0; j--) {
        if (country[i].data[j]['date'].toString() == parsedrecentdate) {
          recent = j;
          break;
        }
      }
      if (recent == -1)
        recent = country[i].data.length - 1;
      table1.add(country[i].country);
      table1.add(country[i].data[recent]['total_vaccinations'].toString());
      table1.add(country[i].data[recent]['people_fully_vaccinated'].toString());
      table1.add(country[i].data[recent]['daily_vaccinations'].toString());
    }
    return table1;
  }
  List<String> makeTable2(){
    String parsedrecentdate;
    List<String> table2=[];
    table2.add("Country");
    table2.add("total");
    table2.add("fully");
    table2.add("daily");
    List<int> total=[];
    int k;
    for(int i=0;i<country.length;i++){
      if(country[i].country == 'South Korea'){
        k = i;
        break;
      }
    }
    parsedrecentdate=country[k].data[country[k].data.length-1]['date'].toString();
    int recent;
    for(int i=0;i<country.length;i++) {
      recent = -1;
      for (int j = country[i].data.length - 1; j >= 0; j--) {
        if (country[i].data[j]['date'].toString() == parsedrecentdate) {
          recent = j;
          break;
        }
      }
      if (recent == -1)
        recent = country[i].data.length - 1;

      total.add(country[i].data[recent]['total_vaccinations']);
    }
    total.sort((a,b)=>b.compareTo(a));

    for(int j=0;j<7;j++) {
      for(int i=0;i<country.length;i++){
        recent = -1;
        for (int j = country[i].data.length - 1; j >= 0; j--) {
          if (country[i].data[j]['date'].toString() == parsedrecentdate) {
            recent = j;
            break;
          }
        }
        if (recent == -1)
          recent = country[i].data.length - 1;

        if (country[i].data[recent]['total_vaccinations'] == total[j]) {
          table2.add(country[i].country);
          table2.add(country[i].data[recent]['total_vaccinations'].toString());
          table2.add(
              country[i].data[recent]['people_fully_vaccinated'].toString());
          table2.add(country[i].data[recent]['daily_vaccinations'].toString());
        }
      }
    }

    return table2;
  }
  @override
  Widget build(BuildContext context){
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 2/1,
        ),
        padding: EdgeInsets.all(5.0),

        itemCount: TableData.length,
        itemBuilder: (context,index){
          return Text(TableData[index],style: TextStyle(fontSize: 12),textAlign: TextAlign.right,);
        }
    );
  }
}



class CountryList extends StatelessWidget{
  final List<Country> country;

  CountryList({Key key, this.country}):super(key: key);

  int find_korea(){
    int korea_index;
    for(int i=0;i<country.length;i++){
      if(country[i].country == 'South Korea'){
        korea_index = i;
        break;
      }
    }
    return korea_index;
  }

  List<FlSpot> makegraph1(){
    List<FlSpot> graph1=[];
    for(int i=6;i>=0;i--){
      graph1.add(FlSpot((6-i).toDouble(), totalVacc(find_korea(),i).toDouble()));
    }
    return graph1;
  }
  List<FlSpot> makegraph2(){
    List<FlSpot> graph2=[];
    for(int i=6;i>=0;i--){
      graph2.add(FlSpot((6-i).toDouble(), dailyVacc(find_korea(),i).toDouble()));
    }
    return graph2;
  }
  List<FlSpot> makegraph3(){
    List<FlSpot> graph3=[];
    for(int i=27;i>=0;i--){
      graph3.add(FlSpot((27-i).toDouble()/4, totalVacc(find_korea(),i).toDouble()));
    }
    return graph3;
  }
  List<FlSpot> makegraph4(){
    List<FlSpot> graph4=[];
    for(int i=27;i>=0;i--){
      graph4.add(FlSpot((27-i).toDouble()/4, dailyVacc(find_korea(),i).toDouble()));
    }
    return graph4;
  }

  int findrecentidx(int f){
    String parsedrecentdate = country[f].data[country[f].data.length-1]['date'].toString();
    int idx;
    for(int i=0;i<country.length;i++) {
      idx = -1;
      for (int j = country[i].data.length - 1; j >= 0; j--) {
        if (country[i].data[j]['date'].toString() == parsedrecentdate) {
          idx = j;
          break;
        }
      }
      if (idx == -1)
        idx = country[i].data.length - 1;
    }
    return idx;
  }
  int totalVacc(int f,int index){
    String parsedrecentdate = country[f].data[country[f].data.length-1]['date'].toString();
    int recent_index;
    int sum=0;
    for(int i=0;i<country.length;i++){
      recent_index=-1;
      for(int j=country[i].data.length-1;j>=0;j--){
        if(country[i].data[j]['date'].toString()==parsedrecentdate) {
          recent_index = j;
          break;
        }
      }
      if(recent_index==-1)
        recent_index=country[i].data.length-1;
      if(recent_index-index<0)
        continue;
      recent_index=recent_index-index;
      if(country[i].data[recent_index]['total_vaccinations']!=null)
        sum+=country[i].data[recent_index]['total_vaccinations'];
      else{
        if(country[i].data[recent_index]['people_vaccinated']!=null)
          sum+=country[i].data[recent_index]['people_vaccinated'];
        else if(country[i].data[recent_index]['people_fully_vaccinated']!=null)
          sum+=country[i].data[recent_index]['people_fully_vaccinated'];
        else
          continue;
      }
    }
    return sum;
  }

  int totalFullyVacc(int f,int index){
    String parsedrecentdate = country[f].data[country[f].data.length-1]['date'].toString();
    int recent_index;
    int sum=0;
    for(int i=0;i<country.length;i++){
      recent_index=-1;
      for(int j=country[i].data.length-1;j>=0;j--){
        if(country[i].data[j]['date'].toString()==parsedrecentdate) {
          recent_index = j;
          break;
        }
      }
      if(recent_index==-1)
        recent_index=country[i].data.length-1;
      if(recent_index-index<0)
        continue;
      recent_index=recent_index-index;
      if(country[i].data[recent_index]['people_fully_vaccinated']!=null)
        sum+=country[i].data[recent_index]['people_fully_vaccinated'];
      else{
        if(recent_index>0){
          if(country[i].data[recent_index-1]['people_fully_vaccinated']!=null)
            sum+=country[i].data[recent_index-1]['people_fully_vaccinated'];
          else
            continue;
        }
      }
    }
    return sum;
  }

  int dailyVacc(int f,int index){
    String parsedrecentdate = country[f].data[country[f].data.length-1]['date'].toString();
    int recent_index;
    int sum=0;
    for(int i=0;i<country.length;i++){
      recent_index=-1;
      for(int j=country[i].data.length-1;j>=0;j--){
        if(country[i].data[j]['date'].toString()==parsedrecentdate) {
          recent_index = j;
          break;
        }
      }
      if(recent_index==-1)
        recent_index=country[i].data.length-1;
      if(recent_index-index<0)
        continue;
      recent_index=recent_index-index;
      if(country[i].data[recent_index]['daily_vaccinations']!=null)
        sum+=country[i].data[recent_index]['daily_vaccinations'];
      else{
        if(recent_index>0){
          if(country[i].data[recent_index-1]['daily_vaccinations']!=null)
            sum+=country[i].data[recent_index-1]['daily_vaccinations'];
          else
            continue;
        }
      }
    }
    return sum;
  }
  @override
  Widget build(BuildContext context){
    return GridView.count(
        padding: EdgeInsets.all(5.0),
        crossAxisCount: 2,
        childAspectRatio: 8/1,
        children: [
          Text("Total Vacc."),
          Text("Parsed latest date",
            textAlign: TextAlign.right,),
          Text(totalVacc(find_korea(),0).toString()+" people"),
          // Text(country[find_korea()].data[1]['total_vaccinations'].toString()+" people"),
          Text(country[find_korea()].data[country[find_korea()].data.length-1]['date'].toString(),
            textAlign: TextAlign.right,),
          Text("Total fully Vacc."),
          Text("Daily Vacc.",
            textAlign: TextAlign.right,),
          Text(totalFullyVacc(find_korea(),0).toString()+" people"),
          Text(dailyVacc(find_korea(),0).toString()+" people",
            textAlign: TextAlign.right,),
        ]
    );

  }
}