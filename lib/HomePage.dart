import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staggered_layout/ResponsiveConstraints.dart';
import 'package:transparent_image/transparent_image.dart';
import 'BottomNav.dart';
import 'DetailedImage.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Widget chip(String label, Color color) {
  return Chip(
    labelPadding: EdgeInsets.all(5.0),
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: color,
    elevation: 6.0,
    shadowColor: Colors.grey[60],
    padding: EdgeInsets.all(10.0),
  );
}

class _HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async{
    // top pull refresh
    print('refreshing');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // bottom scroll refresh
    print('loading');
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
      // on bottom scroll completed
      setState(() {});
    print('load complete');
    _refreshController.loadComplete();
  }
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Responsive.height(1, context)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            alignment: WrapAlignment.end,
            children: <Widget>[
              //SizedBox(width: 20),
              chip('Today', Colors.black),
              // chip('Food', Color(0xFF4fc3f7)),
              // chip('Lifestyle', Color(0xFF9575cd)),
              // chip('Sports', Color(0xFF4db6ac)),
              // chip('Nature', Color(0xFF5cda65)),
              // chip('Learn', Color(0xFFacbb65)),
            ],
          )
        ),
        SizedBox(height: Responsive.height(1, context)),
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: ClassicFooter(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: StaggeredGridView.countBuilder(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
              controller: hideButtonController,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      // Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: DetailedImage(index: index)));
                      MaterialPageRoute route = MaterialPageRoute(builder: (context)=> DetailedImage(index: index));
                      Navigator.push(context, route);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(
                              Radius.circular(30))
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)),
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: imageList[index],
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: imageList[index],fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (index) {
                  return StaggeredTile.fit(1);
                  //return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                }),
          ),
        ),
      ],
    );
  }
}