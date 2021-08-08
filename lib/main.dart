import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oktoast/oktoast.dart';
import 'package:staggered_layout/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:staggered_layout/Questioner.dart';

late final FirebaseApp app;

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp();
  runApp(MyApp());
}

const PrimaryColor = Color(0xFFFEDBD0);
const PrimaryDarkColor = Color(0xFFFBB8AC);
const SecondaryColor = Color(0xFF442C2E);

Map<int, Color> color =
{
  50:Color.fromRGBO(251, 184, 172, 0.10196078431372549),
  100:Color.fromRGBO(251, 184, 172, .2),
  200:Color.fromRGBO(251, 184, 172, .3),
  300:Color.fromRGBO(251, 184, 172, .4),
  400:Color.fromRGBO(251, 184, 172, .5),
  500:Color.fromRGBO(251, 184, 172, .6),
  600:Color.fromRGBO(251, 184, 172, .7),
  700:Color.fromRGBO(251, 184, 172, .8),
  800:Color.fromRGBO(251, 184, 172, .9),
  900:Color.fromRGBO(251, 184, 172, 1),
};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: MaterialColor(0xFF442C2E, color),
            pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }
            )
        ),
        home: LoginScreen(),
        //home:SearchPage()
      ),
    );
  }
}

late DatabaseReference linksRef;
List<String> topWear = [];
List<String> collectionList = [];
List<String> collectionUrl = [];
List<String> collectionListTemp = [];
List<String> collectionUrlTemp = [];

// class _MyHomePageState extends State<MyHomePage> {
//   @override

  // late Map<String, dynamic> map;
  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       body: Stack(
  //         children: [
  //           _children[_currentIndex],
  //           Positioned(
  //             left: Responsive.width(12, context),
  //             right: Responsive.width(12, context),
  //             bottom: Responsive.height(5, context),
  //             child: bottomNavigationBar,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // int _currentIndex = 0;
  // final List<Widget> _children = [
  //   HomePage(),
  //   SearchPage(),
  //   UserProfile()
  // ];

  // Widget get bottomNavigationBar {
  //   return Stack(
  //     children: [
  //       isVisible?AnimatedPositioned(
  //       curve: Curves.easeIn,
  //       duration: Duration(seconds: 10),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(40),
  //           ),
  //           child: BottomNavigationBar(
  //             // type: BottomNavigationBarType.shifting,
  //             enableFeedback: true,
  //             backgroundColor: Colors.white60,
  //             showSelectedLabels: false,
  //             showUnselectedLabels: false,
  //             currentIndex: _currentIndex,
  //             elevation: 0,
  //             items: [
  //               BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '', tooltip: 'Home'),
  //               BottomNavigationBarItem(icon: Icon(Icons.search),label: '' , tooltip: 'Search'),
  //               BottomNavigationBarItem(icon: Icon(Icons.person),label: '', tooltip: 'Profile'),
  //             ],
  //             onTap: (int index){
  //               setState(() {
  //                 _currentIndex = index;
  //               });
  //               //_pageController.jumpToPage(index);
  //             },
  //             selectedIconTheme: IconThemeData(
  //                 color: Colors.black87,
  //                 size: 40
  //             ),
  //             unselectedIconTheme: IconThemeData(
  //                 color: Colors.black26,
  //                 size: 30
  //             ),
  //           ),
  //         )
  //       ):Container()
  //     ],
  //   );
  // }
// }