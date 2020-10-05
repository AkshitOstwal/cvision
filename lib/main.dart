//This app click picture ,saves them and show them
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:provider/provider.dart';
import './providers/images_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ImagesProvider(),
      child: MaterialApp(
        title: 'CVision',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
    
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    print(savedImage);
    Provider.of<ImagesProvider>(context).addImages(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var _storedImages = Provider.of<ImagesProvider>(context).images;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('CVision.ai'),
        elevation: 20,
      ),
      body: Container(
        height: height,
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (ctx, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                child: GestureDetector(
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Image No ${i+1}'),
                            content: Image(
                    image: FileImage(_storedImages[i]),
                  ),
                            actions: <Widget>[
                             
                              FlatButton(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Provider.of<ImagesProvider>(context)
                                      .deleteImage(i);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Image(
                    image: FileImage(_storedImages[i]),
                  ),
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black87,
                  title: Text(
                    "Image no ${i + 1}",
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sure you want to delete !!!'),
                              content: Text(
                                  'The image once deleted can not be retrived!!! '),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Provider.of<ImagesProvider>(context)
                                        .deleteImage(i);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            );
          },
          itemCount: _storedImages.length,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: _takePicture,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you done !!!'),
                    content: Text(
                        'Total no of images taken are : ${_storedImages.length}'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Done'),
            backgroundColor: Colors.purple,
          )
        ],
      ),
    );
  }
}
