import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pa3/pages/LoginComplete.dart';
import 'package:pa3/pages/StartLive.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<List<Casedata>> fetchCasedata(http.Client client) async{
  String url = 'https://covid.ourworldindata.org/data/owid-covid-data.json';
  await Future.delayed(Duration(seconds: 5));
  final response = await http.get(Uri.parse('https://covid.ourworldindata.org/data/owid-covid-data.json'));
  //print(response.body);
//return jsonDecode(response.body);
  return compute(parseCasedata, response.body);
}

List<Casedata> parseCasedata(String responseBody){
  List<dynamic> arr=[];
  dynamic p = jsonDecode(responseBody);
  p.forEach((key,value)=> {if(value!=null) {arr.add(value)}});
  //print(p.toString());
  //print(arr.toString());
  dynamic parsed = arr.cast<Map<String, dynamic>>();
  // parsed.forEach((keys)=>'c');
  //print(parsed['c'][0]);
  return parsed.map<Casedata>((json)=>Casedata.fromJson(json)).toList();
}
class Casedata{
  final String location;
  final dynamic data;

  Casedata({
    @required this.location, @required this.data});
  factory Casedata.fromJson(Map<String, dynamic>json){
    return Casedata(
      location: json['location'] as String,
      data: json['data'] as dynamic,
    );
  }
}

class CasesDeath extends StatelessWidget {
  TextEditingController usrid;
  final String page = "Cases/Death Page";
  List<FlSpot> spotData = [];
  List<FlSpot> graph1 = [];
  List<FlSpot> graph2 = [];
  List<FlSpot> graph3 = [];
  List<FlSpot> graph4 = [];
  List<String> TableData0=[];
  List<String> TableData1=[];
  List<String> TableData2=[];
  double interv;

  CasesDeath({Key key, @required this.usrid}):super(key:key);

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
              FutureBuilder<List<Casedata>>(
                future:fetchCasedata(http.Client()),
                builder:(context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);
                  if(snapshot.hasData){
                    TableData1=CaseTable(casedata: snapshot.data,).makeTable1();
                    TableData2=CaseTable(casedata: snapshot.data,).makeTable2();
                  }
                  return snapshot.hasData
                      ? Center(child:CasedataList(casedata : snapshot.data))
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
                          interv=2000000;
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
                          interv=100000;
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
                          interv=20000000;
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
                          interv=500000;
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
                          FutureBuilder<List<Casedata>>(
                            future:fetchCasedata(http.Client()),
                            builder:(context, snapshot){
                              if(snapshot.hasError) print(snapshot.error);
                              else if(snapshot.hasData){
                                graph1=CasedataList(casedata : snapshot.data).makegraph1();
                                graph2=CasedataList(casedata : snapshot.data).makegraph2();
                                graph3=CasedataList(casedata : snapshot.data).makegraph3();
                                graph4=CasedataList(casedata : snapshot.data).makegraph4();
                                if(spotData.length==0) {
                                  spotData = graph1;
                                  interv=2000000;
                                }
                              }
                              return snapshot.hasData
                                  ? Center(child:Graphs(spotData:spotData,casedata: snapshot.data, interv:interv))
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
                            child: Text("Total Cases",
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
                            child: Text("Total Deaths",
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
                        FutureBuilder<List<Casedata>>(
                          future:fetchCasedata(http.Client()),
                          builder:(context, snapshot){
                            if(snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? Center(child:CaseTable(casedata: snapshot.data, TableData: TableData0,))
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
            MaterialPageRoute(builder:(context)=>StartLive(usrid: usrid,page: page,)),
          );
        },
        child:Icon(Icons.list),
    ),
    );
  }
}

class Graphs extends StatelessWidget{
  List<FlSpot> spotData;
  List<Casedata> casedata;
  List<String> dateData;
  double interv;
  Graphs({Key key, this.spotData,this.casedata, this.interv}):super(key: key);

  List<String> dateList(){
    List<String> dateData=[];
    int korea_index;
    for(int i=0;i<casedata.length;i++){
      if(casedata[i].location == 'South Korea'){
        korea_index = i;
        break;
      }
    }
    if(spotData.length==7) {
      for (int i = 0; i < 7; i++)
        dateData.add(
            casedata[korea_index].data[casedata[korea_index].data.length - 1 - i]['date'].toString().substring(5));
    }
    else {
      for (int i = 0; i < 7; i++)
        dateData.add(casedata[korea_index].data[casedata[korea_index].data.length - 1-7*i ]['date'].toString().substring(5));
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

class CaseTable extends StatelessWidget{
  final List<Casedata> casedata;
  CaseTable({Key key, this.casedata, this.TableData}):super(key: key);
  List<String> TableData;

  List<String> makeTable1(){
    String parsedrecentdate;
    List<String> table1=[];
    table1.add("Country");
    table1.add("total cases");
    table1.add("daily cases");
    table1.add("total deaths");
    List<int> total=[];
    int k;
    for(int i=0;i<casedata.length;i++){
      if(casedata[i].location == 'South Korea'){
        k = i;
        break;
      }
    }
    parsedrecentdate=casedata[k].data[casedata[k].data.length-1]['date'].toString();
    int recent;
    for(int i=0;i<casedata.length;i++) {
      recent = -1;
      for (int j = casedata[i].data.length - 1; j >= 0; j--) {
        if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
          recent = j;
          break;
        }
      }
      if (recent == -1)
        recent = casedata[i].data.length - 1;
      if(casedata[i].data[recent]['total_cases']!=null)
        total.add(casedata[i].data[recent]['total_cases'].toInt());
    }
    total.sort((a,b)=>b.compareTo(a));

    for(int j=0;j<7;j++) {
      for(int i=0;i<casedata.length;i++){
        recent = -1;
        for (int j = casedata[i].data.length - 1; j >= 0; j--) {
          if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
            recent = j;
            break;
          }
        }
        if (recent == -1)
          recent = casedata[i].data.length - 1;

        if (casedata[i].data[recent]['total_cases'] == total[j]) {
          table1.add(casedata[i].location);
          if(casedata[i].data[recent]['total_cases']!=null)
            table1.add(casedata[i].data[recent]['total_cases'].toInt().toString());
          else
            table1.add(casedata[i].data[recent]['total_cases'].toString());
          if(casedata[i].data[recent]['new_cases']!=null)
            table1.add(casedata[i].data[recent]['new_cases'].toInt().toString());
          else
            table1.add(casedata[i].data[recent]['new_cases'].toString());
          if(casedata[i].data[recent]['total_deaths']!=null)
            table1.add(casedata[i].data[recent]['total_deaths'].toInt().toString());
          else
            table1.add(casedata[i].data[recent]['total_deaths'].toString());
        }
      }
    }
    return table1;
  }
  List<String> makeTable2(){
    String parsedrecentdate;
    List<String> table2=[];
    table2.add("Country");
    table2.add("total cases");
    table2.add("daily cases");
    table2.add("total deaths");
    List<int> total=[];
    int k;
    for(int i=0;i<casedata.length;i++){
      if(casedata[i].location == 'South Korea'){
        k = i;
        break;
      }
    }
    parsedrecentdate=casedata[k].data[casedata[k].data.length-1]['date'].toString();
    int recent;
    for(int i=0;i<casedata.length;i++) {
      recent = -1;
      for (int j = casedata[i].data.length - 1; j >= 0; j--) {
        if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
          recent = j;
          break;
        }
      }
      if (recent == -1)
        recent = casedata[i].data.length - 1;
      if(casedata[i].data[recent]['total_deaths']!=null)
        total.add(casedata[i].data[recent]['total_deaths'].toInt());
    }
    total.sort((a,b)=>b.compareTo(a));

    for(int j=0;j<7;j++) {
      for(int i=0;i<casedata.length;i++){
        recent = -1;
        for (int j = casedata[i].data.length - 1; j >= 0; j--) {
          if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
            recent = j;
            break;
          }
        }
        if (recent == -1)
          recent = casedata[i].data.length - 1;

        if (casedata[i].data[recent]['total_deaths'] == total[j]) {
          table2.add(casedata[i].location);
          if(casedata[i].data[recent]['total_cases']!=null)
            table2.add(casedata[i].data[recent]['total_cases'].toInt().toString());
          else
            table2.add(casedata[i].data[recent]['total_cases'].toString());
          if(casedata[i].data[recent]['new_cases']!=null)
            table2.add(casedata[i].data[recent]['new_cases'].toInt().toString());
          else
            table2.add(casedata[i].data[recent]['new_cases'].toString());
          if(casedata[i].data[recent]['total_deaths']!=null)
            table2.add(casedata[i].data[recent]['total_deaths'].toInt().toString());
          else
            table2.add(casedata[i].data[recent]['total_deaths'].toString());
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

class CasedataList extends StatelessWidget{
  final List<Casedata> casedata;
  CasedataList({Key key, this.casedata}):super(key: key);

  int find_korea(){
    int korea_index;
    for(int i=0;i<casedata.length;i++){
      if(casedata[i].location == 'South Korea'){
        korea_index = i;
        break;
      }
    }
    return korea_index;
  }

  List<FlSpot> makegraph1(){
    List<FlSpot> graph1=[];
    for(int i=6;i>=0;i--){
      graph1.add(FlSpot((6-i).toDouble(), totalCases(find_korea(),i).toDouble()));
    }
    return graph1;
  }
  List<FlSpot> makegraph2(){
    List<FlSpot> graph2=[];
    for(int i=6;i>=0;i--){
      graph2.add(FlSpot((6-i).toDouble(), dailyCases(find_korea(),i).toDouble()));
    }
    return graph2;
  }
  List<FlSpot> makegraph3(){
    List<FlSpot> graph3=[];
    for(int i=27;i>=0;i--){
      graph3.add(FlSpot((27-i).toDouble()/4, totalCases(find_korea(),i).toDouble()));
    }
    return graph3;
  }
  List<FlSpot> makegraph4(){
    List<FlSpot> graph4=[];
    for(int i=27;i>=0;i--){
      graph4.add(FlSpot((27-i).toDouble()/4, dailyCases(find_korea(),i).toDouble()));
    }
    return graph4;
  }
 int totalCases(int f, int index){
    String parsedrecentdate = casedata[f].data[casedata[f].data.length-1]['date'].toString();
    int recent_index;
    double sum=0;
    for(int i=0;i<casedata.length;i++) {
      if (casedata[i].data.length > 0) {
        recent_index = -1;
        for (int j = casedata[i].data.length - 1; j >= 0; j--) {
          if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
            recent_index = j;
            break;
          }
        }
        if (recent_index == -1)
          recent_index = casedata[i].data.length - 1;
        if (recent_index - index < 0)
          continue;
        recent_index = recent_index - index;

        if (casedata[i].data[recent_index]['total_cases'] != null)
          sum += casedata[i].data[recent_index]['total_cases'];
        else {
          if(recent_index-1>=0) {
            if (casedata[i].data[recent_index - 1]['total_cases'] != null)
              sum += casedata[i].data[recent_index - 1]['total_cases'];
            else
              continue;
          }
        }
      }
    }
    return sum.toInt();
  }
  int totalDeaths(int f, int index){
    String parsedrecentdate = casedata[f].data[casedata[f].data.length-1]['date'].toString();
    int recent_index;
    double sum=0;
    for(int i=0;i<casedata.length;i++) {
      if (casedata[i].data.length > 0) {
        recent_index = -1;
        for (int j = casedata[i].data.length - 1; j >= 0; j--) {
          if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
            recent_index = j;
            break;
          }
        }
        if (recent_index == -1)
          recent_index = casedata[i].data.length - 1;
        if (recent_index - index < 0)
          continue;
        recent_index = recent_index - index;

        if (casedata[i].data[recent_index]['total_deaths'] != null)
          sum += casedata[i].data[recent_index]['total_deaths'];
        else {
          if(recent_index-1>=0) {
            if (casedata[i].data[recent_index - 1]['total_deaths'] != null)
              sum += casedata[i].data[recent_index - 1]['total_deaths'];
            else
              continue;
          }
        }
      }
    }
    return sum.toInt();
  }
  int dailyCases(int f, int index){
    String parsedrecentdate = casedata[f].data[casedata[f].data.length-1]['date'].toString();
    int recent_index;
    double sum=0;
    for(int i=0;i<casedata.length;i++) {
      if (casedata[i].data.length > 0) {
        recent_index = -1;
        for (int j = casedata[i].data.length - 1; j >= 0; j--) {
          if (casedata[i].data[j]['date'].toString() == parsedrecentdate) {
            recent_index = j;
            break;
          }
        }
        if (recent_index == -1)
          recent_index = casedata[i].data.length - 1;
        if (recent_index - index < 0)
          continue;
        recent_index = recent_index - index;

        if (casedata[i].data[recent_index]['new_cases'] != null)
          sum += casedata[i].data[recent_index]['new_cases'];
        else {
          if(recent_index-1>=0) {
            if (casedata[i].data[recent_index - 1]['new_cases'] != null)
              sum += casedata[i].data[recent_index - 1]['new_cases'];
            else
              continue;
          }
        }
      }
    }
    return sum.toInt();
  }


  @override
  Widget build(BuildContext context){
    return GridView.count(
        padding: EdgeInsets.all(5.0),
        crossAxisCount: 2,
        childAspectRatio: 8/1,
        children: [
          Text("Total Cases."),
          Text("Parsed latest date", textAlign: TextAlign.right,),
          Text(totalCases(find_korea(),0).toString()+" people"),
          Text(casedata[find_korea()].data[casedata[find_korea()].data.length-1]['date'].toString(), textAlign: TextAlign.right,),
          Text("Total Deaths"),
          Text("Daily Cases.",textAlign: TextAlign.right,),
          Text(totalDeaths(find_korea(),0).toString()+" people"),
          Text(dailyCases(find_korea(),0).toString()+" people",textAlign: TextAlign.right,),
    ]
    );

  }
}