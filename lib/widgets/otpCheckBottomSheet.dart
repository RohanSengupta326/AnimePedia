import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../api/seriesdata.dart';

class OtpCheck extends StatefulWidget {
  String _phone;

  OtpCheck(this._phone);

  @override
  State<OtpCheck> createState() => _OtpCheckState();
}

class _OtpCheckState extends State<OtpCheck> {
  final SeriesData controller = Get.find();
  RxString verificationCode = '222222'.obs;
  late UserCredential userCredential;
  RxBool _isLoading = false.obs;

  _verifyPhone() async {
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: '+91${widget._phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        _isLoading.value = true;
        userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential)
            .catchError((err) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Something Went wrong, Please try again later!',
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
        });
        Navigator.of(context).pop();
        _isLoading.value = false;
      },
      verificationFailed: (FirebaseAuthException e) {
        ;
      },
      codeSent: (String verificationId, forceResendingToken) {
        verificationCode.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationCode.value = verificationId;
      },
      timeout: Duration(seconds: 60),
    )
        .catchError((err) {
      _isLoading.value = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Something Went wrong! If recieved OTP then type it in below.',
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
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: context.mediaQueryViewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Verification',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'If didn\'t get verified automatically then\nEnter the code sent to the number\n+91 ${widget._phone}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Obx(() {
              return _isLoading.value
                  ? SizedBox(
                      child: Center(
                          child: CircularProgressIndicator(
                      color: Colors.amber,
                    )))
                  : OtpTextField(
                      textStyle: TextStyle(color: Colors.black),
                      numberOfFields: 6,
                      borderColor: Colors.amber,
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      cursorColor: Colors.amber,
                      enabledBorderColor: Colors.amber,
                      focusedBorderColor: Colors.amber,

                      //runs when every textfield is filled
                      onSubmit: ((value) async {
                        FirebaseAuth.instance
                            .signInWithCredential(
                          PhoneAuthProvider.credential(
                              verificationId: verificationCode.value,
                              smsCode: value),
                        )
                            .catchError((err) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'OTP is incorrect!',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: ButtonStyle(
                                          shadowColor: MaterialStatePropertyAll(
                                              Colors.amber),
                                          elevation:
                                              MaterialStatePropertyAll(8),
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.amber),
                                        ),
                                        child: Text('Ok!'),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }).then((value) {
                          Navigator.of(context).pop();
                        });
                      }),
                    );
            }),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
