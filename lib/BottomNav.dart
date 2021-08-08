import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'HomePage.dart';
import 'ResponsiveConstraints.dart';
import 'SearchPage.dart';
import 'UserProfile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

bool isVisible = true;
ScrollController hideButtonController = new ScrollController();
List<String> homeList = [];
List<String> imageList =[];

class _BottomNavState extends State<BottomNav> {

  void initState() {
    super.initState();

    isVisible = true;
    hideButtonController = new ScrollController();
    hideButtonController.addListener(() {
      if (hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true)
          setState(() {
            isVisible = false;
          });
      } else {
        if (hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false)
            setState(() {
              isVisible = true;
            });
        }
      }
    });

    FirebaseFirestore.instance.collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString()).collection('homepage')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          homeList.add(doc["category"]);
          homeList.add(doc["article"]);
          homeList.add(doc["style"]);
          print(homeList);
        });
      });
    }).whenComplete((){
      print('write here');
      for(int i=0; i<homeList.length; i=i+3){
        FirebaseFirestore.instance.collection('newImagesData')
            .where('${homeList[i]}.${homeList[i+1]}.${'Style'}', isEqualTo: homeList[i+2])
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            setState(() {
              print(doc["url"]);
              imageList.add(doc["url"]);
              //topWear.add(doc['']);
              //print(doc.id);
            });
          });
        });
      }
    });


    // FirebaseFirestore.instance.collection('newImagesData')
    // .where('TopWear.Crop Top.Style', isEqualTo: 'Casual')
    // .where('BottomWear.Skirt.Style', isEqualTo: 'Casual')
    // .where('FootWear.Flip Flop.Style', isEqualTo: 'Casual')
    // //.where('topWear.Coat.color', arrayContainsAny: ['black'])
    // .get()
    //   .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     setState(() {
    //       print(doc["url"]);
    //       imageList.add(doc["url"]);
    //       //topWear.add(doc['']);
    //       //print(doc.id);
    //     });
    //   });
    // });



    // FirebaseFirestore.instance
    //     .collection('Users').doc('userID').collection('tasteGraph')
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     String wear = (doc['wear']);
    //     String type = (doc['type']);
    //     String pattern = (doc['pattern']);
    //     String color = (doc['color']);
    //     String gender = (doc['gender']);
    //     print('wear: ${wear}Wear');
    //     print('${wear}Type: $type');
    //     print('${wear}Pattern: $pattern');
    //     print('${wear}Color: $color');
    //     print('gender: $gender');
    //     FirebaseFirestore.instance
    //         .collection('AmanImages')
    //         .where('${wear}Wear', isEqualTo: true)
    //         .where('gender', isEqualTo: gender)
    //         .where('${wear}Color', arrayContainsAny: [color])
    //         .where('${wear}Type', isEqualTo: type)
    //         //.where('age', isEqualTo: '21')
    //         .orderBy('time', descending: true).limit(10)
    //         .get()
    //         .then((QuerySnapshot querySnapshot) {
    //       querySnapshot.docs.forEach((doc) {
    //         print(doc["originalUrl"]);
    //         setState(() {
    //           imageList.add(doc["originalUrl"]);
    //         });
    //       });
    //     });
    //   });
    // });
    // imageList.clear();
    // FirebaseFirestore.instance
    //     .collection('AmanImages')
    //     .where('bottomWear', isEqualTo: true)
    //     .where('gender', isEqualTo: 'F')
    //     //.where('bottomColor', arrayContainsAny: ['white'])
    //     //.where('bottomType', isEqualTo: 'pajami')
    //     //.where('age', isEqualTo: '21')
    //     //.orderBy('time', descending: true).limit(10)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((doc) {
    //     print(doc["originalUrl"]);
    //     setState(() {
    //       imageList.add(doc["originalUrl"]);
    //     });
    //   });
    // });
    // linksRef = FirebaseDatabase.instance.reference().child('Links');
    // final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    // database.reference().child('Links').get().then((DataSnapshot? snapshot) {
    //   Map<dynamic, dynamic> values = snapshot!.value;
    //   if(values.isNotEmpty) {
    //     imageList.clear();
    //     values.forEach((key, values) {
    //       imageList.add(values);
    //     });
    //   }
    // });
    // database.setPersistenceEnabled(true);
    // database.setPersistenceCacheSizeBytes(10000000);
    // linksRef.keepSynced(true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _children[_currentIndex],
            Positioned(
              left: Responsive.width(12, context),
              right: Responsive.width(12, context),
              bottom: Responsive.height(5, context),
              child: bottomNavigationBar,
            )
          ],
        ),
      ),
    );
  }
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    SearchPage(),
    UserProfile()
  ];

  Widget get bottomNavigationBar {
    return Stack(
      children: [
        isVisible?AnimatedPositioned(
            curve: Curves.easeIn,
            duration: Duration(seconds: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(40),
              ),
              child: BottomNavigationBar(
                // type: BottomNavigationBarType.shifting,
                enableFeedback: true,
                backgroundColor: Colors.white60,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _currentIndex,
                elevation: 0,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '', tooltip: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.search),label: '' , tooltip: 'Search'),
                  BottomNavigationBarItem(icon: Icon(Icons.person),label: '', tooltip: 'Profile'),
                ],
                onTap: (int index){
                  setState(() {
                    _currentIndex = index;
                  });
                  //_pageController.jumpToPage(index);
                },
                selectedIconTheme: IconThemeData(
                    color: Colors.black87,
                    size: 40
                ),
                unselectedIconTheme: IconThemeData(
                    color: Colors.black26,
                    size: 30
                ),
              ),
            )
        ):Container()
      ],
    );
  }
}
