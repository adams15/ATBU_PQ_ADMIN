// import 'package:atbupq_admin/styles/colors.dart';
// import 'package:atbupq_admin/styles/fonts.dart';
// import 'package:atbupq_admin/widgets/banner_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

// class Banners extends StatefulWidget {
//   const Banners({super.key});
//   static const String routeName = '\Banners';

//   @override
//   State<Banners> createState() => _BannersState();
// }

// class _BannersState extends State<Banners> {
//   dynamic _image;
//   String? _imageName;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // pick image
//   pickImage() async {
//     FilePickerResult? result = await FilePicker.platform
//         .pickFiles(allowMultiple: false, type: FileType.image);

//     // store the picked image in a global variable
//     if (result != null) {
//       setState(() {
//         _image = result.files.first.bytes;
//         // getting the image name
//         _imageName = result.files.first.name;
//       });
//     }
//   }

//   // upload banner to firebase Storage
//   uploadBannerToFirebaseStorage(dynamic images) async {
//     Reference ref = _storage.ref().child('Banners').child(_imageName!);
//     UploadTask uploadTask = ref.putData(images);
//     TaskSnapshot snapshot = await uploadTask;
//     // get the download url
//     String downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   // upload to firestore
//   uploadBannerToFirestore() async {
//     EasyLoading.show();
//     if (_image != null) {
//       String imageUrl = await uploadBannerToFirebaseStorage(_image);
//       //store to firestore
//       await _firestore.collection('Banners').doc(_imageName).set({
//         'image': imageUrl,
//       }).whenComplete(() {
//         EasyLoading.dismiss();
//         setState(() {
//           _image = null;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Container(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Text(
//                 'Banners',
//                 style: kbodylargeboldText,
//               ),
//             ),
//           ),
//           const Divider(
//             color: Colors.grey,
//             height: 1,
//             thickness: 1,
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Row(
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       height: 140,
//                       width: 140,
//                       decoration: BoxDecoration(
//                         color: coolGreyColor,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: _image != null
//                           ? Image.memory(
//                               _image,
//                               fit: BoxFit.cover,
//                             )
//                           : Center(
//                               child: Text(
//                                 ' Upload Banners',
//                                 style: kbodysmallwhitecolor,
//                               ),
//                             ),
//                     ),
//                     const SizedBox(
//                       height: 25,
//                     ),
//                     ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: primaryColor),
//                         onPressed: () {
//                           pickImage();
//                         },
//                         child: Text(
//                           'Pick Image',
//                           style: kbodysmallwhitecolor,
//                         ))
//                   ],
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//                 ElevatedButton(
//                     style:
//                         ElevatedButton.styleFrom(backgroundColor: primaryColor),
//                     onPressed: () {
//                       uploadBannerToFirestore();
//                     },
//                     child: Text(
//                       'Upload Image',
//                       style: kbodysmallwhitecolor,
//                     ))
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 25,
//           ),
//           const Divider(
//             color: Colors.grey,
//             height: 1,
//             thickness: 1,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Container(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Banners',
//                 style: kbodylargeboldText,
//               ),
//             ),
//           ),
//           const BannerWidget(),
//         ],
//       ),
//     );
//   }
// }

import 'package:atbupq_admin/styles/colors.dart';
import 'package:atbupq_admin/styles/fonts.dart';
import 'package:atbupq_admin/widgets/banner_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key});
  static const String routeName = '\Banners';

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  dynamic _image;
  String? _imageName;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // pick image
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    // store the picked image in a global variable
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        // getting the image name
        _imageName = result.files.first.name;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  // upload banner to firebase Storage
  uploadBannerToFirebaseStorage(dynamic images) async {
    try {
      Reference ref = _storage.ref().child('Banners').child(_imageName!);
      UploadTask uploadTask = ref.putData(images);
      TaskSnapshot snapshot = await uploadTask;
      // get the download url
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image')),
      );
      throw e;
    }
  }

  // upload to firestore
  uploadBannerToFirestore() async {
    EasyLoading.show();
    if (_image != null) {
      try {
        String imageUrl = await uploadBannerToFirebaseStorage(_image);
        //store to firestore
        await _firestore.collection('Banners').doc(_imageName).set({
          'image': imageUrl,
        }).whenComplete(() {
          EasyLoading.dismiss();
          setState(() {
            _image = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image uploaded successfully')),
          );
        });
      } catch (e) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Banners',
                style: kbodylargeboldText,
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: coolGreyColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _image != null
                          ? Image.memory(
                              _image,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text(
                                ' Upload Banners',
                                style: kbodysmallwhitecolor,
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () {
                          pickImage();
                        },
                        child: Text(
                          'Pick Image',
                          style: kbodysmallwhitecolor,
                        ))
                  ],
                ),
                const SizedBox(
                  width: 25,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    onPressed: () {
                      uploadBannerToFirestore();
                    },
                    child: Text(
                      'Upload Image',
                      style: kbodysmallwhitecolor,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Banners',
                style: kbodylargeboldText,
              ),
            ),
          ),
          const BannerWidget(),
        ],
      ),
    );
  }
}
