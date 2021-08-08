import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:staggered_layout/main.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

import 'BottomNav.dart';
import 'CustomToast.dart';

class DetailedImage extends StatefulWidget {
  final index;

  DetailedImage({required this.index});

  @override
  _DetailedImageState createState() => _DetailedImageState();
}

List<String> otherList = [
  'https://i.pinimg.com/750x/b1/c6/5f/b1c65f09601633a01f3b45505e3c56b7.jpg',
  'https://i.pinimg.com/564x/80/41/5d/80415d5e701b5f29a119d70221f31f12.jpg',
  'https://i.pinimg.com/originals/50/e4/95/50e4952ec21be842bc2aa2a0fcf17335.jpg',
  'https://stalkbuylove.files.wordpress.com/2012/09/aayushi.jpg',
  'http://media.vogue.in/wp-content/uploads/2015/03/3%202.jpg',
  'https://i1.wp.com/thefashionfrill.com/wp-content/uploads/2021/05/Aashna-Shroff.jpg?w=1080&ssl=1'
  'https://www.beyondpinkworld.com/Assets/PageContent/1555245826408.jpg',
  'https://i.pinimg.com/474x/42/58/1f/42581fc057fc67d6a7078455f007055d.jpg'
];

TextEditingController newCollectionController = TextEditingController();

bool addedToCollection = false;

class _DetailedImageState extends State<DetailedImage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Hero(
                            tag: imageList[widget.index],
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: imageList[widget.index],
                              // height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                            right: 15,
                            bottom: 15,
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: InkWell(
                                onTap: (){},
                                child: Ink(
                                  // width: 60,
                                  // height: 60,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white70,
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            isDismissible: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                DraggableScrollableSheet(
                                                  initialChildSize: 0.4,
                                                  minChildSize: 0.2,
                                                  maxChildSize: 0.6,
                                                  builder: (context, scrollController) {
                                                    return Container(
                                                      decoration: new BoxDecoration (
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.only(topLeft:Radius.circular(30), topRight: Radius.circular(30))
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          SingleChildScrollView(
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(top: 10.0, bottom: 55),
                                                                child: Column(
                                                                  children: [
                                                                    collectionList.isEmpty?
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(30.0),
                                                                          child: Center(child: Text('No Collection found', style: TextStyle(color: Colors.grey, fontSize: 20),)),
                                                                        ):
                                                                Text('Add to Collection', style: TextStyle(fontSize: 20, ),textAlign: TextAlign.center),
                                                                    ListView.builder(
                                                                       physics: NeverScrollableScrollPhysics(),
                                                                        shrinkWrap: true,
                                                                        scrollDirection: Axis.vertical,
                                                                        itemCount:
                                                                        collectionList.length,
                                                                        itemBuilder: (context, index) {
                                                                          return Material(
                                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
                                                                            // type: MaterialType.transparency,
                                                                            child: Ink(
                                                                              decoration: BoxDecoration(
                                                                                  borderRadius:
                                                                                  BorderRadius.all(Radius.circular(30))),
                                                                              child: InkWell(
                                                                                onTap: (){},
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(
                                                                                      //color: Colors.red,
                                                                                        border: Border.all(
                                                                                          color: Colors.black,  // red as border color
                                                                                        ),
                                                                                      borderRadius:
                                                                                      BorderRadius.all(Radius.circular(5))),
                                                                                        child: ListTile(
                                                                                          leading: Container(
                                                                                            height: Responsive.height(10, context),
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                              child: collectionUrl[index*4]=='null'?Icon(Icons.image):Image.network(collectionUrl[index*4],fit: BoxFit.fitWidth,),
                                                                                            ),
                                                                                          ),
                                                                                          title: Text(
                                                                                              '${collectionList[index]}'),
                                                                                          onTap: () async{
                                                                                            print('tapped');
                                                                                            FirebaseFirestore.instance
                                                                                                .collection('newImagesData')
                                                                                                .where('url', isEqualTo: imageList[widget.index])
                                                                                                .get()
                                                                                                .then((QuerySnapshot querySnapshot) {
                                                                                              querySnapshot.docs.forEach((doc) async {
                                                                                                Map<String, dynamic> myMap = doc.data()
                                                                                                as Map<String, dynamic>;

                                                                                                String time = Timestamp.now().seconds.toString();
                                                                                                Map<String, dynamic> data = <String, dynamic>{
                                                                                                  "collectionTime": time
                                                                                                };

                                                                                                await FirebaseFirestore.instance
                                                                                                    .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                                    .collection('collections')
                                                                                                    .doc(collectionList[index])
                                                                                                    .collection('data')
                                                                                                    .doc(time)
                                                                                                    .set(data)
                                                                                                    .then((value) => print('timeDone'));

                                                                                                await FirebaseFirestore.instance
                                                                                                    .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                                    .collection('collections')
                                                                                                    .doc(collectionList[index])
                                                                                                    .collection('data')
                                                                                                    .doc(time)
                                                                                                    .update(myMap)
                                                                                                    .then((value) => print('done'));

                                                                                                await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                                    .collection('collections').where('collectionName', isEqualTo: collectionList[index])
                                                                                                    .get()
                                                                                                    .then((QuerySnapshot querySnapshot) {
                                                                                                  querySnapshot.docs.forEach((doc) async{
                                                                                                    String link1 = await myMap['url'];
                                                                                                    String link2 = await doc['recentUrl1'];
                                                                                                    String link3 = await doc['recentUrl2'];
                                                                                                    String link4 = await doc['recentUrl3'];
                                                                                                    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                                        .collection('collections').doc(collectionList[index])
                                                                                                        .update({
                                                                                                      'recentUrl1': link1,
                                                                                                      'recentUrl2': link2,
                                                                                                      'recentUrl3': link3,
                                                                                                      'recentUrl4': link4,
                                                                                                    }).then((value) => print('recentUrlUpdated'));
                                                                                                  });
                                                                                                });

                                                                                                await FirebaseFirestore.instance
                                                                                                    .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                                    .collection('tasteGraph')
                                                                                                    .doc(time)
                                                                                                    .set(myMap)
                                                                                                    .then((value) => print('tasteGraph'));

                                                                                                await immediateLoad();

                                                                                                Navigator.pop(context);

                                                                                                showToastWidget(
                                                                                                    ToastWidget(
                                                                                                      title: 'Added to collection',
                                                                                                      description: collectionList[index],
                                                                                                      link: myMap['url'],
                                                                                                    ),
                                                                                                    position: ToastPosition.bottom,
                                                                                                    duration: Duration(seconds: 5),
                                                                                                  onDismiss: (){
                                                                                                    setState(() {
                                                                                                      addedToCollection = true;
                                                                                                    });
                                                                                                  },
                                                                                                );
                                                                                                });
                                                                                            });
                                                                                          }),
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        }
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                          Positioned(
                                                            bottom: 10,
                                                            left: 0,
                                                            right: 0,
                                                            child: InkWell(
                                                              child: MaterialButton(
                                                                onPressed: (){
                                                                  print('pressed');
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (BuildContext context){
                                                                        return AlertDialog(
                                                                            shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(20),),
                                                                          title: Text('Create new Collection'),
                                                                          content: TextField(
                                                                            textInputAction: TextInputAction.done,
                                                                            textCapitalization: TextCapitalization.words,
                                                                            autofocus: true,
                                                                            controller: newCollectionController,
                                                                            decoration: InputDecoration(
                                                                              labelText: 'Collection Name',
                                                                              border: new OutlineInputBorder(
                                                                                borderRadius: const BorderRadius.all(
                                                                                  const Radius.circular(10.0),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          actions: [
                                                                            MaterialButton(
                                                                              onPressed: ()async{
                                                                                await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                    .collection('collections').doc(newCollectionController.text)
                                                                                    .set({
                                                                                  'collectionName': newCollectionController.text,
                                                                                  'recentUrl1': 'null',
                                                                                  'recentUrl2': 'null',
                                                                                  'recentUrl3': 'null',
                                                                                  'recentUrl4': 'null',
                                                                                });

                                                                                await FirebaseFirestore.instance
                                                                                    .collection('newImagesData')
                                                                                    .where('url', isEqualTo: imageList[widget.index])
                                                                                    .get()
                                                                                    .then((QuerySnapshot querySnapshot) {
                                                                                  querySnapshot.docs.forEach((doc) async {
                                                                                    Map<String, dynamic> myMap = doc.data()
                                                                                    as Map<String, dynamic>;

                                                                                    String time = Timestamp.now().seconds.toString();
                                                                                    Map<String, dynamic> data = <String, dynamic>{
                                                                                      "collectionTime": time
                                                                                    };

                                                                                    await FirebaseFirestore.instance
                                                                                        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                        .collection('collections')
                                                                                        .doc(newCollectionController.text)
                                                                                        .collection('data')
                                                                                        .doc(time)
                                                                                        .set(data)
                                                                                        .then((value) => print('timeDone'));

                                                                                    await FirebaseFirestore.instance
                                                                                        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                        .collection('collections')
                                                                                        .doc(newCollectionController.text)
                                                                                        .collection('data')
                                                                                        .doc(time)
                                                                                        .update(myMap)
                                                                                        .then((value) => print('done'));

                                                                                    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                        .collection('collections').where('collectionName', isEqualTo:newCollectionController.text)
                                                                                        .get()
                                                                                        .then((QuerySnapshot querySnapshot) {
                                                                                      querySnapshot.docs.forEach((doc) async{
                                                                                        String link1 = await myMap['url'];
                                                                                        String link2 = await doc['recentUrl1'];
                                                                                        String link3 = await doc['recentUrl2'];
                                                                                        String link4 = await doc['recentUrl3'];
                                                                                        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                            .collection('collections').doc(newCollectionController.text)
                                                                                            .update({
                                                                                          'recentUrl1': link1,
                                                                                          'recentUrl2': link2,
                                                                                          'recentUrl3': link3,
                                                                                          'recentUrl4': link4,
                                                                                        }).then((value) => print('recentUrlUpdated'));
                                                                                      });
                                                                                    });

                                                                                    await FirebaseFirestore.instance
                                                                                        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
                                                                                        .collection('tasteGraph')
                                                                                        .doc(time)
                                                                                        .set(myMap)
                                                                                        .then((value) => print('tasteGraph'));

                                                                                    await immediateLoad();

                                                                                    showToastWidget(
                                                                                      ToastWidget(
                                                                                        title: 'Added to collection',
                                                                                        description: newCollectionController.text,
                                                                                        link: myMap['url'],
                                                                                      ),
                                                                                      position: ToastPosition.bottom,
                                                                                      duration: Duration(seconds: 5),
                                                                                      onDismiss: (){
                                                                                        setState(() {
                                                                                          addedToCollection=true;
                                                                                        });
                                                                                      },
                                                                                    );
                                                                                    newCollectionController.text = '';
                                                                                    Navigator.pop(context);
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                });
                                                                                },
                                                                              child: Text(
                                                                                  'Create'
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      }
                                                                  );
                                                                },
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                  child: Container(
                                                                    color: PrimaryColor,
                                                                    height: 50,
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Icon(Icons.add),
                                                                        Text('Create new Collection')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                          );
                                        },
                                        icon: Icon(addedToCollection?Icons.bookmark:Icons.bookmark_border, size: 30,)),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.all(12),
                    child: StaggeredGridView.countBuilder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        itemCount: otherList.length,
                        itemBuilder: (context, indexx) {
                          return GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(15)),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: otherList[indexx],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.fit(1);
                        }),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 5,
              // Material(
              // shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(50.0)),
              // child: InkWell(
              // onTap: (){},
              // child: Ink(
              // // width: 60,
              // // height: 60,
              // child: Container(
              child: Container(
                height: 70,
                width: 70,
                child: Material(
                  type: MaterialType.transparency,
                  borderRadius: BorderRadius.circular(100.0),
                  child: InkWell(
                    onTap: (){},
                    child: Ink(
                      child: Container(
                        // decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        // ),
                        child: IconButton(
                          onPressed: () {
                            print('pressed');
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadCollection();
    loadSimilarImages();
  }

  immediateLoad() async{
    print('loaded');
    collectionListTemp.clear();
    collectionUrlTemp.clear();
    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('collections').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          collectionListTemp.add(doc['collectionName']);
          collectionUrlTemp.add(doc['recentUrl1']);
          collectionUrlTemp.add(doc['recentUrl2']);
          collectionUrlTemp.add(doc['recentUrl3']);
          collectionUrlTemp.add(doc['recentUrl4']);
        });
      });
    }).whenComplete((){
      setState(() {
        collectionList = collectionListTemp;
        collectionUrl = collectionUrlTemp;
      });
    });
  }

  void loadCollection() async{
    print('loaded');
    collectionListTemp.clear();
    collectionUrlTemp.clear();
    await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('collections').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          collectionListTemp.add(doc['collectionName']);
          collectionUrlTemp.add(doc['recentUrl1']);
          collectionUrlTemp.add(doc['recentUrl2']);
          collectionUrlTemp.add(doc['recentUrl3']);
          collectionUrlTemp.add(doc['recentUrl4']);
        });
      });
    }).whenComplete((){
      setState(() {
        collectionList = collectionListTemp;
        collectionUrl = collectionUrlTemp;
      });
    });
  }

  void loadSimilarImages() {
    otherList = [];
    FirebaseFirestore.instance.collection('newImagesData')
    .where('bottomWear.Jeans.color', arrayContainsAny: ['blue'])
    // .where('accessories.Glasses.material', isEqualTo: 'plastic')
    //.where('topWear.Coat.color', arrayContainsAny: ['black'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          print(doc["url"]);
          imageList.add(doc["url"]);
          //print(doc.id);
        });
      });
    });
  }
}
