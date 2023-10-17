// import 'package:aves_species/screens/fetch.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class ImagePickerExample extends StatefulWidget {
//   @override
//   _ImagePickerExampleState createState() => _ImagePickerExampleState();
// }

// class _ImagePickerExampleState extends State<ImagePickerExample> {
//   File? _image;
//   String fileName = "";
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: source);
//     setState(() {
//       if (pickedImage != null) {
//         _image = File(pickedImage.path);
//       } else {
//         print('No image selected.');
//       }
//     });
// final storageReference = FirebaseStorage.instance
//         .ref()
//         .child('images/${_image!.path.split('/').last}');
//     final uploadTask = storageReference.putFile(_image!);
//     final snapshot = await uploadTask.whenComplete(() => null);
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//     fileName=_image!.path.split('/').last;
//   }

//   Future predict() async {
//     showDialog(
//       context: this.context,
//       builder: (context) {
//         return const Center(child: CircularProgressIndicator());  
//       },
//     );
//     http.Response res = await http.get(
//         Uri.parse("https://0229-103-206-114-42.in.ngrok.io/?query=$fileName"));
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Example'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: _image == null
//                 ? Text('No image selected.')
//                 : Image.file(_image!),
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: predict,
//             child: Text('Predict'),
//           ),
//           SizedBox(height: 16.0),
//           ElevatedButton(
//             onPressed: fetchData,
//             child: Text('fetch'),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Select an image'),
//                 content: SingleChildScrollView(
//                   child: ListBody(
//                     children: [
//                       GestureDetector(
//                         child: Text('Pick from gallery'),
//                         onTap: () {
//                           _pickImage(ImageSource.gallery);
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                       SizedBox(height: 16.0),
//                       GestureDetector(
//                         child: Text('Take a photo'),
//                         onTap: () {
//                           _pickImage(ImageSource.camera);
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         tooltip: 'Pick Image',
//         child: Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }
import 'package:aves_species/screens/second.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:web_socket_channel/io.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;
  final channel = IOWebSocketChannel.connect('wss://0hiutyz0c8.execute-api.us-east-1.amazonaws.com/production');

  String fileName = "";
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${_image!.path.split('/').last}');
    final uploadTask = storageReference.putFile(_image!);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    fileName=_image!.path.split('/').last;
  }

  Future predict() async {
    // Show loading dialog
    showDialog(
      context: this.context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    http.Response res = await http.get(Uri.parse("https://0229-103-206-114-42.in.ngrok.io?query=$fileName"));

    channel.stream.listen((message) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(url: message),
          settings: const RouteSettings(name: '/second'),
        ),
      );
    });
    channel.sink.add(fileName);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _image == null
                ? const Text('No image selected.')
                : Image.file(_image!),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: predict,
            child: const Text('Predict'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select an image'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      GestureDetector(
                        child: const Text('Pick from gallery'),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        child: const Text('Take a photo'),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}