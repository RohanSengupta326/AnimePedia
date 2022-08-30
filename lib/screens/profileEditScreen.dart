import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/homepage.dart';

import '../widgets/uploadImage.dart';

class ProfileEditScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final SeriesData controller = Get.find();
  String _userName = '';
  XFile? _pickedImage;

  void imagePicker(XFile? image) {
    _pickedImage = image;
  }

  void onSubmitted(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      if (_pickedImage == null &&
          (controller.currentUserData.isEmpty &&
              controller.currentUserData[0].dpUrl == '')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Please upload a profile picture!',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(Colors.amber),
                      elevation: MaterialStatePropertyAll(8),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      backgroundColor: MaterialStatePropertyAll(Colors.amber),
                    ),
                    child: Text('Ok!'),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        XFile? userDp;

        userDp = _pickedImage != null ? _pickedImage as XFile : null;

        if (_userName == '' && userDp != null) {
          _userName = controller.currentUserData[0].username == ''
              ? 'Unknown'
              : controller.currentUserData[0].username;
        }

        controller.saveNewUserData(_userName.trim(), userDp).catchError(
          (error) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(HomePage());
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          shadowColor: MaterialStatePropertyAll(Colors.amber),
                          elevation: MaterialStatePropertyAll(8),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber),
                        ),
                        child: Text('Ok!'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ).then((value) {
          Get.back();
          controller.fetchUserData().catchError((onError) {
            print(onError);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Text(
                    'Change/Set Profile Picture and Username',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    //dont take as much space as possible but as minimum as needed
                    children: <Widget>[
                      UploadImage(imagePicker),
                      SizedBox(height: 16),
                      Container(
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          cursorColor: Colors.amber,
                          key: ValueKey('username'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.amber,
                              ),
                            ),
                            focusColor: Colors.amber,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.amber,
                              ),
                            ),
                            hintText:
                                controller.currentUserData[0].username == ''
                                    ? 'Unknown'
                                    : controller.currentUserData[0].username,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onSaved: (value) {
                            _userName = value as String;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (controller.isSaveUserDataLoading == true)
                        CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      if (controller.isSaveUserDataLoading == false)
                        SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () => onSubmitted(context),
                            style: ButtonStyle(
                              shadowColor:
                                  MaterialStatePropertyAll(Colors.amber),
                              elevation: MaterialStatePropertyAll(8),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.amber),
                            ),
                            child: Text('Save'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
