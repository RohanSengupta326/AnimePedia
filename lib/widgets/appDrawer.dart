import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:series/api/seriesdata.dart';
import 'package:series/screens/favouritesScreen.dart';
import 'package:series/screens/profileEditScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:device_apps/device_apps.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final SeriesData controller = Get.find();
  static int firstFetch = 1;
  final String developerInstaUrl = 'https://www.instagram.com/rohaaansen/';
  final String developerTwitterUrl = 'https://twitter.com/rohan_sen132';
  final String developerLinkedInUrl =
      'https://www.linkedin.com/in/rohan-sengupta-193bb916a/';

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

  Future<void> _launchUrl(String uri, String appPackageName) async {
    final Uri url = Uri.parse(uri);

    bool isInstalled = await DeviceApps.isAppInstalled(appPackageName);

    if (isInstalled) {
      AndroidIntent intent = AndroidIntent(
        action: 'action_view',
        data: url as String?,
      );
      await intent.launch();
    } else {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        // to open in youtube
      )) {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Align(
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
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 25),
                      child: Align(
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
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                        onPressed: () {
                          firstFetch = 0;
                          Get.to(ProfileEditScreen());
                        },
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.amber,
                        ),
                        label: Text(
                          'Profile',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton.icon(
                        onPressed: () => Get.to(FavouritesScreen()),
                        icon: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        label: Text(
                          'Favourites',
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
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
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 16,
                bottom: 8,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Created By Rohan Sengupta',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () =>
                        _launchUrl(developerInstaUrl, 'com.instagram.android'),
                    icon: FaIcon(FontAwesomeIcons.instagram),
                  ),
                  IconButton(
                    onPressed: () =>
                        _launchUrl(developerTwitterUrl, 'com.twitter.android'),
                    icon: FaIcon(FontAwesomeIcons.twitter),
                  ),
                  IconButton(
                    onPressed: () => _launchUrl(
                        developerLinkedInUrl, 'com.linkedin.android'),
                    icon: FaIcon(FontAwesomeIcons.linkedin),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
