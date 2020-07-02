import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';

class mainpage extends StatefulWidget {
  @override
  _mainpageState createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  String status;
  String errmgs = 'Error Uploading Image';
  File tmpFile;
  String base64Image;

  var _imageserverpath; //网页图片地址
  var image; //上传的图片
  File _imagePath;
  bool ifclick = false; //是否进行处理
  bool check = false;
  bool _camera = false; //是否是照相机，是要经过处理

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Center(child: Text('Wart Diagnosis')),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
                width: 100,
                child: Image.asset('images/top.png'),
              ),
              _Imageview(_imagePath),
//                   showImage(),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      onPressed: () {
                        ifclick = false;
                        _openGallery();
                      },
                      child: Text('Upload A Picture'),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: FlatButton(
                      color: Colors.white,
                      textColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                      onPressed: () {
                        ifclick = false;
                        _camera = true;
                        _takePhoto();
                        print(_imagePath);
                      },
                      child: Text('Take A Picture'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        ifclick = false;
                        _cropimage();
                      },
                      icon: Icon(
                        Icons.crop,
                        size: 30.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        icon: Icon(
                          Icons.refresh,
                          size: 30.0,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            ifclick = false;
                            _imagePath = null;
                            _imageserverpath = null;
                            image = null;
                          });
                        }),
                  ),
                ],
              ),
              IconButton(
                iconSize: 50,
                color: Colors.blue,
                splashColor: Colors.blue,
                icon: Icon(Icons.search),
                padding: EdgeInsets.all(10),
                onPressed: () {
                  setState(() {
                    ifclick = true;
                    _uploadImage();
                  });
                },
              ),
              Showresult(),
              FloatingActionButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Icon(Icons.exit_to_app),
                backgroundColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Showresult() {
    if (!ifclick) {
      return Text('Click the search icon to show the result !');
    } else if (image != null && _camera == false) {
      return Column(
        children: <Widget>[
          Text('Wait a second ...'),
          SpinKitWave(
            color: Colors.blue,
            size: 20,
          ),
        ],
      );
    } else if (_camera = true && image != null) {
      return Text('Please crop the picture !');
    } else {
      return Text('Please choose a picture !');
    }
  }

  Widget _Imageview(imagepath) {
    if (imagepath == null) {
      return Container(
        width: 200,
        height: 200,
        child: Center(child: Text('Please upload a picture or take a picture')),
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        child: Image.file(imagepath),
      );
    }
  }

  /*拍照*/
  _takePhoto() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imagePath = image;
    });
  }

  /*相册*/
  Future<void> _openGallery() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image;
    });
  }

  Future<void> _cropimage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imagePath.path,
      maxHeight: 512,
      maxWidth: 512,
    );
    setState(() {
      _camera = false;
      _imagePath = cropped ?? _imagePath;
    });
  }
//  upload() async {
////    var url = 'http://192.168.1.102/flutterproject/upload';
//    var url = 'http://jd.itying.com/imgupload';
//    var bytes = image.readAsStringSync();
//
//    var name = url.substring(url.lastIndexOf("/") + 1, url.length);
//    var _image = await MultipartFile.fromFile(url, filename: name);
//    FormData formData = FormData.fromMap({"image": _image});
//
//    var response = await Dio().post(url,data: formData);
//
//    print(response);
//    if (response.statusCode == 200){
//      Map reponseMap = response.data;
//      print("http://jd.itying.com${reponseMap["path"]}");
//      setState(() {
//          _imageserverpath = "http://jd.itying.com${reponseMap["path"]}";
//      });
//
//
//    }
//  }

  Future<void> _uploadImage() async {
    FormData formData = FormData.from({
      "file": UploadFileInfo(_imagePath, "imageName.png"),
    });
    var response =
        await Dio().post("http://jd.itying.com/imgupload", data: formData);
    print(response);
    if (response.statusCode == 200) {
      Map responseMap = response.data;
      print("http://jd.itying.com${responseMap["path"]}");
      setState(() {
        _imageserverpath = "http://jd.itying.com${responseMap["path"]}";
        responseMap = null;
        response = null;
      });
    }
  }
}
