import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Maruthuvan/utils/customcard.dart';

class Detect extends StatefulWidget {
  @override
  _DetectState createState() => _DetectState();
}

class _DetectState extends State<Detect> {
  List _outputs;
  File _image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB5DFEA),
      appBar: AppBar(
        title: const Text('Fish Species Finder'),
        backgroundColor: Color(0xFF33B9CB),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: _loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null
                        ? Column(
                            children: [
                              InkWell(
                                  child: Text(
                                    "Hi there",
                                    style: GoogleFonts.fredokaOne(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                  onTap: pickImage),
                              Container(
                                height: 550,
                                width: 400,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/howto.png"))),
                              ),
                            ],
                          )
                        : Image.file(_image),
                    SizedBox(
                      height: 20,
                    ),
                    _outputs != null
                        ? Column(
                            children: [
                              Text(
                                "Identified fishes",
                                style: GoogleFonts.fredokaOne(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Container(
                                            height: 400,
                                            child: StreamBuilder(
                                              stream: Firestore.instance
                                                  .collection("species")
                                                  .snapshots(),
                                              builder: (cx, snap) {
                                                return snap.data == null
                                                    ? Container()
                                                    : ListView.separated(
                                                        itemBuilder: (ctx, i) {
                                                          var man = snap.data
                                                              .documents[i];
                                                          return CustomCard(
                                                            data: man["name"],
                                                            color: Colors.blue,
                                                            sub: man["weight"],
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (ctx, i) =>
                                                                SizedBox(
                                                          height: 10,
                                                        ),
                                                        itemCount: snap.data
                                                            .documents.length,
                                                      );
                                              },
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: Icon(Icons.image),
      ),
    );
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}