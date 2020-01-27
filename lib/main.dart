import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intro_slider/intro_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}
class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}


class _IntroScreenState extends State<IntroScreen> {

List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Get All Prescriptions",
        description: "Get all prescriptions digitally and give the medicines on a first come first serve basis",
        pathImage: "assets/Images/pharma.jpg",
        backgroundColor: const Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "Keep record of sales!",
        description: "Keep record of all the sales that will help you in better inventory management",
        pathImage: "assets/Images/pharma1.jpg",
        backgroundColor: const Color(0xff203152),
      ),
    );
  }

  void onDonePress() {
    // TODO: go to next screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
          ListPage(),    
      )
    );
  }

  void onSkipPress() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
          ListPage(),    
      )
    );
  }


  @override
 Widget build(BuildContext context) {
    return Scaffold(
      body:IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    ),);
    }
}
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  
  void _launchURL(url1) async {
  var url = url1;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
  
    var firestore = Firestore.instance;
  Future getReports() async{
    QuerySnapshot qn = await firestore.collection("reportsUrl").getDocuments();
    print(qn.documents);
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          
          backgroundColor: Colors.white,
          body: new Container(
            
            child: Container(
          
          child: FutureBuilder(
            future: getReports(),
            builder: (_,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return SpinKitFoldingCube(
  color: Colors.blue,
  size: 50.0,
);

            }
            else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_,index){
                      print(snapshot.data[index].data);
                      print(snapshot.data[index].data["status"]);
                      if(snapshot.data[index].data["status"] == true){
                      return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                      children: <Widget>[
                        Image(
                          image: NetworkImage("https://us.123rf.com/450wm/llesia/llesia1603/llesia160300030/53519430-clipboard-in-his-hand-doctor-hand-holding-clipboard-with-checklist-and-pen-for-medical-report-presen.jpg?ver=6"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(snapshot.data[index].data["patient_id"],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          
                        ),
                        MaterialButton(
            minWidth: double.infinity,
            onPressed: (){
                firestore.collection('reportsUrl').document(snapshot.data[index].data["patient_id"]).updateData({"status":false});
                 setState(() {
                   
                 });        
            },
            color: Colors.cyan,
            elevation: 20.0,
            child: Text("Mark as done",style: TextStyle(color: Colors.white),),
          ),  MaterialButton(
            minWidth: double.infinity,
            onPressed: (){
              _launchURL(snapshot.data[index].data["pdf_url"]);
            },
            color: Colors.cyan,
            elevation: 20.0,
            child: Text("View Prescription",style: TextStyle(color: Colors.white),),
          ),  
                      ],
                    ),
                ),
              );
                      }
                      else{
                        return SizedBox(height: 0.0);
                      }
                  },
                );
            }
          },),
      ),
          )
    );
  }
}