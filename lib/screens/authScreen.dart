import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:series/api/seriesdata.dart';

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
  RxBool _isLogin = false.obs;

  XFile? _pickedImage;

  void onSubmitted() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      controller.authUser(_userEmail.trim(), _userName.trim(),
          _userPassword.trim(), _isLogin.value, _pickedImage);
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
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 150),
          child: Obx(() {
            return Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        //dont take as much space as possible but as minimum as needed
                        children: <Widget>[
                          if (!_isLogin.value) UploadImage(imagePicker),
                          Container(
                            height: 45,
                            child: TextFormField(
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
                          if (!_isLogin.value)
                            Container(
                              height: 45,
                              child: TextFormField(
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
                          Container(
                            height: 45,
                            child: TextFormField(
                              cursorColor: Colors.amber,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 7) {
                                  return 'please enter a password of atleast 7 characters long';
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
                              obscureText: true,
                              // hidden(*****)
                              onSaved: (value) {
                                _userPassword = value as String;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          if (controller.isLoadingAuth == true)
                            CircularProgressIndicator(),
                          if (controller.isLoadingAuth == false)
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                onPressed: onSubmitted,
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
                                child:
                                    Text(_isLogin.value ? 'LogIn' : 'SignUp'),
                              ),
                            ),
                          SizedBox(
                            height: 50,
                          ),
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
                        ],
                      ),
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
