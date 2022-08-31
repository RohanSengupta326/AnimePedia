import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:series/api/seriesdata.dart';
import 'package:series/widgets/otpCheckBottomSheet.dart';

import '../widgets/uploadImage.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = Get.put(SeriesData());
  final GlobalKey<FormState> _formKey = GlobalKey();

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  String _phone = '';
  RxBool _isLogin = false.obs;
  RxBool _isPhone = false.obs;

  XFile? _pickedImage;

  void onSubmitted(BuildContext context) {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_isPhone.value) {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: ((context) {
            return OtpCheck(_phone);
          }),
        );
      } else {
        if (_pickedImage == null && !_isLogin.value) {
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
          if (!_isLogin.value) {
            userDp = _pickedImage as XFile;
          }
          controller
              .authUser(_userEmail.trim(), _userName.trim(),
                  _userPassword.trim(), _isLogin.value, userDp)
              .catchError(
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
                          onPressed: () => Navigator.of(context).pop(),
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
          );
        }
      }
    }
  }

  void imagePicker(XFile? image) {
    _pickedImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Obx(() {
            return Column(
              children: [
                // design
                SizedBox(
                  height: 40,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      'Welcome to ',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Text(
                      'AnimePedia',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //dont take as much space as possible but as minimum as needed
                      children: <Widget>[
                        if (!_isLogin.value && !_isPhone.value)
                          UploadImage(imagePicker),
                        SizedBox(height: 16),
                        if (!_isPhone.value)
                          Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.amber,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'please enter valid email address';
                                }
                                return null;
                              },
                              key: ValueKey('email'),
                              keyboardType: TextInputType.emailAddress,
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
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusColor: Colors.amber,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.amber,
                                  ),
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              onSaved: (value) {
                                _userEmail = value as String;
                              },
                            ),
                          ),
                        SizedBox(
                          height: 16,
                        ),
                        if (!_isLogin.value && !_isPhone.value)
                          Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.amber,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return 'please enter username of atleast 4 characters';
                                }

                                return null;
                              },
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
                                hintText: 'Username',
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
                        if (!_isPhone.value)
                          Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.amber,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'password should be atleast 7 characters long';
                                }
                                return null;
                              },
                              key: ValueKey('password'),
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
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              obscureText: false,
                              onSaved: (value) {
                                _userPassword = value as String;
                              },
                            ),
                          ),
                        if (_isPhone.value)
                          Container(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.amber,
                              key: ValueKey('Phone Number'),
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
                                hintText: '1234567890',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                _phone = value as String;
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 50,
                        ),
                        if (controller.isLoadingAuth == true)
                          CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        if (controller.isLoadingAuth == false)
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
                              child: Text(_isPhone.value
                                  ? 'Send OTP'
                                  : _isLogin.value
                                      ? 'LogIn'
                                      : 'SignUp'),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '--- OR ---',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                          onPressed: () {
                            _isPhone.value = !_isPhone.value;
                          },
                          child: Text(
                            _isPhone.value
                                ? 'SignUp with Email'
                                : 'SignUp with phone',
                            style: TextStyle(
                                color: Colors.grey.shade700, fontSize: 16),
                          ),
                        ),
                        if (!_isPhone.value)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isLogin.value
                                    ? 'Dont\'t have an account ? '
                                    : 'Already have an account ?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.amber),
                                ),
                                onPressed: () {
                                  _isLogin.value = !_isLogin.value;
                                },
                                child: Text(
                                  _isLogin.value ? 'Register' : 'LogIn',
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
