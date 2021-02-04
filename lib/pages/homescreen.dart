import 'package:flutter/material.dart';
import 'package:Maruthuvan/utils/header.dart';
import 'package:Maruthuvan/utils/customcard.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> show;
  @override
  Widget build(BuildContext context) {
    setState(() => this.show = symptomList);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Landing()));
        },
        child: Icon(Icons.check),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF33B9CB),
      ),
      body: Scaffold(
        backgroundColor: Color(0xFFB5DFEA),
        body: Column(children: [
          HeaderWithSearchBox(
            size: MediaQuery.of(context).size,
            addSym: (value) => setState(() {
              symptomList.add(value);
            }),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Marketplace",
                  style:
                      GoogleFonts.fredokaOne(fontSize: 20, color: Color(0xFF3C4046)),
                  textAlign: TextAlign.left,
                ),
              ),
                          Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 2),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ListView.separated(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue,
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/carousel1.png",
                              ),
                              fit: BoxFit.cover)),
                      width: 250.0,
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                ),
              ),
            ),

            ]),
          )
        ]),
      ),
    );
  }
}

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Detected: aaa"),
          elevation: 0,
          backgroundColor: Color(0xFF33B9CB),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/sample.jpg",
                  height: 300,
                ),
                Text(
                  "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    ""),
                Text(
                  "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "")
              ],
            ),
          ),
        ));
  }
}
