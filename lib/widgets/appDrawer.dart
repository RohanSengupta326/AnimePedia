import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final SeriesData controller = Get.find();
  static int firstFetch = 0;

  getUserData() {
    if (firstFetch > 0) {
      // dont fetch if already fetched once, user data
      return;
    }
    firstFetch++;
    controller.fetchUserData().catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 30),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Obx(() {
                          return controller.isLoadingUserData.value
                              ? CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : CircleAvatar(
                                  radius: 30,
                                  backgroundImage: controller
                                              .currentUserData.isNotEmpty &&
                                          controller.currentUserData[0].dpUrl !=
                                              ''
                                      ? NetworkImage(
                                          controller.currentUserData[0].dpUrl)
                                      : AssetImage('assets/images/userdp.jpg')
                                          as ImageProvider<Object>,
                                );
                        })),
                    SizedBox(
                      height: 12,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Obx(() {
                          return controller.isLoadingUserData.value
                              ? CupertinoActivityIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  controller.currentUserData.isNotEmpty &&
                                          controller.currentUserData[0]
                                                  .username !=
                                              ''
                                      ? controller.currentUserData[0].username
                                      : 'Unknown',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                );
                        })),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 16),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () => controller.logOut(),
                        icon: Icon(
                          Icons.logout_outlined,
                          color: Colors.amber,
                        ),
                        label: Text(
                          'LogOut',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
