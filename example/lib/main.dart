import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

void main() => runApp(new MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String fileName;
  List<Filter> filters = presetFiltersList;
  File imageFile;
  final picker = ImagePicker();
  Future getImage(context) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    fileName = basename(imageFile.path);
    var image = imageLib.decodeImage(imageFile.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          backgroundColor: Color(0xFFf6dfcd),
          appBarColor: Color(0xFF30110D),
          textColor: Color(0xFFF722620),
          borderColor: Color(0xFFF2BC94),
          appBarIconColor: Color(0xFFF2BC94),
          title: Text("Photo Filter Example"),
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFile = imagefile['image_filtered'];
      });
      print(imageFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photo Filter Example'),
      ),
      body: Center(
        child: new Container(
          child: imageFile == null
              ? Center(
                  child: new Text('No image selected.'),
                )
              : Image.file(imageFile),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => getImage(context),
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}
